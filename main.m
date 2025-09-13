disp("Starting Orbitron Jet Simulator...");

# Start TCP server for communication
tcp_socket();

% Known values
m_dot = 20;          % Mass Flow Rate [kg/s]
V_in = 510;          % Inlet air velocity [m/s]
T0_in = 288;         % Inlet Air Temperature Measured [K]
P0_in = 101325;      % Inlet Air pressure [Pa]
R = 287.05;          % Gas constant for air [J/kg.K]

[m_dot, P0_in, T0_in ] = compressor_inlet(m_dot, V_in, T0_in, P0_in, R );

# The Shaft will produce the N value
[ N, w ] = shaft(T_turb, T_comp, T_wind, T_frict, T_acc, init_state);

compressor(m_dot, N, P0_in, T0_in);
