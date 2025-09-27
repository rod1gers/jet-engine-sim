% COMPRESSOR INLET

function [m_dot, P0_in, T0_in, Ca1 ] = compressor_inlet(client_socket, m_dot, T0_in, P0_in, R, rho, r_tip_in, r_root_in)
  
  % Inlet area and diameter calculation
  A = annulus_area(r_root_in, r_tip_in)   % Area [m^2]
  D = sqrt((4 * A) / pi);          % Diameter [m]
  
  V_in = m_dot / rho * A;
  
  # Return to ECU the velocity of Air at inlet
  send_msg_to_ecu(client_socket, "Inlet Velocity", V_in, "m/s");
  
  # Since there are no IGVs
  Ca1 = V_in;  
  
  disp(["Inlet Total temperature: ", num2str(T0_in), " K"]);
end