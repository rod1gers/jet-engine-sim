disp("Starting Orbitron Jet Simulator...");

# Start TCP server for communication
server_socket = tcp_socket();

addpath("components");
addpath("utils");


# Engine physical state
global starterValveOpen;
global engine_running;
starterValveOpen = false;
engine_running = false;
  
% Known values
m_dot = 20;          % Mass Flow Rate [kg/s]
T0_in = 288;         % Inlet Air Temperature Measured [K]
P0_in = 101325;      % Inlet Air pressure [Pa]
R = 287.05;          % Gas constant for air [J/kg.K]
Cp = 1005;           % Specific heat at constant pressure [J/kg.K]
rho = P0_in / (R * T0_in);           % Density of air [kg/m^3]
r_tip_in = 0.2262;      #[m]
r_root_in = 0.1131;     #[m]

# Shaft state initialization
state = struct();
state.w = 0;         % Angular velocity [rad/s]
state.theta = 0;     % Angular position [rad]
N = 0;               % RPM

# Shaft parameters
I = 10;              % Moment of inertia [kg·m²]
Cf = 0.5;            % Friction coefficient
Kw = 0.01;           % Windage coefficient
T_acc = 10;          % Accessory torque [N·m]

# Simulation time parameters
dt = 0.05;           % Time step [s] - 50ms (20Hz update rate)
t = 0;               % Current simulation time
t_last_send = 0;     % Last time we sent data to client
send_interval = 0.1; % Send data every 100ms

connection_status = false;

while true
  try 
    printf("Waiting for client connection...\n");
    client_socket = accept(server_socket);

    printf("✅ Client connected!\n");
    connection_status = true;
    
    commands = cmd_mapping();
    
    t = 0;
    state.w = 0;
    N = 0;
    T_turb = 0;
    PowProd_turb = 0;
    
    while connection_status
        tic;
        
        msg = recv(client_socket, 1024, MSG_DONTWAIT);
        
        if !isempty(msg)
          raw = char(msg');
          printf("📥 Received: %s\n", raw);
          
          # Decode and handle command
          data = jsondecode(raw);
          cmd = data.command;
          
          if isKey(commands, cmd)
            handler = commands(cmd);
            handler();  # This might set starterValveOpen, etc.
          else
            printf("⚠️ Unknown command: %s\n", cmd);
          endif
        endif
        
        # Air Getting into the inlet
        [m_dot, P0_in, T0_in, Ca1 ] = compressor_inlet(m_dot, T0_in, P0_in, R, rho, r_tip_in, r_root_in);

        # N should be read from shaft
        [P0_out, T0_out, m_dot, PowReq_comp ] = compressor(m_dot, N, P0_in, T0_in, Cp, Ca1);

        # Starter torque (based on current state)
        if (starterValveOpen)
          T_starter = calculateStarterTorque(N);
        else
          T_starter = 0;
        endif
        
        # The Shaft will produce the N value
        # Return the N value to the ECU for transmission back to the ECAM
        [ N, w_new, T_net ] = shaft(T_turb, T_starter, PowReq_comp, PowProd_turb, T_acc, state, I, Cf, Kw, dt);

        state.w = w_new;
        state.theta = state.theta + w_new * dt;
        
        if (t - t_last_send >= send_interval)
          # Package data
          state_data = struct();
          state_data.time = t;
          state_data.N = N;
          state_data.T_net = T_net;
          state_data.T_starter = T_starter;
          state_data.P0_out = P0_out;
          state_data.T0_out = T0_out;
          state_data.m_dot = m_dot;
          state_data.starterValveOpen = starterValveOpen;
          
          # Send as batch
          send_engine_state_to_ecu(client_socket, state_data);
          
          t_last_send = t;
        endif
        
        t = t + dt;
        
        elapsed = toc;
        if (elapsed < dt)
          pause(dt - elapsed);  # Sleep to maintain dt timing
        else
          printf("⚠️ Warning: Iteration took %.3f s (target: %.3f s)\n", 
                 elapsed, dt);
        endif

      catch inner_err
        printf("Inner loop error: %s\n", inner_err.message);
        # Force reconnection
        connection_status = false;
      end_try_catch
      
    endwhile    
  catch err
    printf("Error: %s\n", err.message);
    pause(1);
  end_try_catch    
endwhile
