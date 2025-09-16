disp("Starting Orbitron Jet Simulator...");

# Start TCP server for communication
server_socket = tcp_socket();

addpath("components");
addpath("utils");

client_socket = accept(server_socket);

% Known values
m_dot = 20;          % Mass Flow Rate [kg/s]
V_in = 510;          % Inlet air velocity [m/s]
T0_in = 288;         % Inlet Air Temperature Measured [K]
P0_in = 101325;      % Inlet Air pressure [Pa]
R = 287.05;          % Gas constant for air [J/kg.K]
# At start N is 0
N = 0;

# Air Getting into the inlet
[m_dot, P0_in, T0_in ] = compressor_inlet(client_socket ,m_dot, V_in, T0_in, P0_in, R);

# N should be read from shaft
[P0_out, T0_out, m_dot, PowReq_comp ] = compressor(m_dot, N, P0_in, T0_in)

# The Shaft will produce the N value
# Return the N value to the ECU for transmission back to the ECAM

# Let's start by passing the Turbine Torque manually and see the effects
[ N, w_new, T_net ] = shaft(T_turb, PowReq_comp, PowProd_turb, T_acc, state, I, Cf, Kw, dt)

send_msg_to_ecu(client_socket, N);


