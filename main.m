disp("Starting Orbitron Jet Simulator...");

# Start TCP server for communication
server_socket = tcp_socket();

addpath("components");
addpath("utils");

connection_status = false;
  
% Known values
m_dot = 20;          % Mass Flow Rate [kg/s]
T0_in = 288;         % Inlet Air Temperature Measured [K]
P0_in = 101325;      % Inlet Air pressure [Pa]
R = 287.05;          % Gas constant for air [J/kg.K]
Cp = 1005;           % Specific heat at constant pressure [J/kg.K]
rho = P0_in / R * T0_in;           % Density of air [kg/m^3]
r_tip_in = 0.2262;      #[m]
r_root_in = 0.1131;     #[m]

# At start N is 0
N = 0;

while true
  try 
    printf("Waiting for client connection...\n");
    client_socket = accept(server_socket);

    printf("✅ Client connected!\n");
    connection_status = true;
    
    while connection_status
      try
        # Wait for data from client
        msg = recv(client_socket, 1024);
        
        if isempty(msg)
          # Client disconnected
          connection_status = false;
          printf("⚠️ Client disconnected\n");
          # close(client_socket);
          break;
        endif
        
        printf("📥 Received this: %s\n", char(msg'));
        
        # Air Getting into the inlet
        [m_dot, P0_in, T0_in, Ca1 ] = compressor_inlet(client_socket ,m_dot, T0_in, P0_in, R, rho, r_tip_in, r_root_in);

        # N should be read from shaft
        [P0_out, T0_out, m_dot, PowReq_comp ] = compressor(client_socket, m_dot, N, P0_in, T0_in, Cp, Ca1);

        # The Shaft will produce the N value
        # Return the N value to the ECU for transmission back to the ECAM

        # Let's start by passing the Turbine Torque manually and see the effects
        # [ N, w_new, T_net ] = shaft(T_turb, PowReq_comp, PowProd_turb, T_acc, state, I, Cf, Kw, dt)

        # send_msg_to_ecu(client_socket, "Sent this");

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