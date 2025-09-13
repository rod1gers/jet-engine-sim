% COMPRESSOR INLET

function [m_dot, P0_in, T0_in ] = compressor_inlet(m_dot, V_in, T0_in, P0_in, R )
  % Inlet area and diameter calculation
  A = ( m_dot * R * T0_in ) / ( P0_in * V_in );   % Area [m^2]
  D = sqrt((4 * A) / pi);                % Diameter [m]
  
  

end