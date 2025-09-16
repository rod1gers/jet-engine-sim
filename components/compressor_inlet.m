% COMPRESSOR INLET

function [m_dot, P0_in, T0_in ] = compressor_inlet(client_socket, m_dot, V_in, T0_in, P0_in, R)
  % Inlet area and diameter calculation
  A = ( m_dot * R * T0_in ) / ( P0_in * V_in );   % Area [m^2]
  D = sqrt((4 * A) / pi);                % Diameter [m]
  
  # Return to ECU the velocity of Air at inlet
  send_msg_to_ecu(client_socket, "V_in", V_in, "m/s");
  
  disp(["Inlet Total temperature: ", num2str(T0_in), " K"]);
end