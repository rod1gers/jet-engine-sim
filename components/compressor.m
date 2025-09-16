# COMPRESSOR COMPONENT
# Has stages where compression occurs and temperature rises
# Each stage has a rotor and a stator

# Preliminary calculations offers 7 stage compressor.

# INPUTS                                         # STATE                                     # OUTPUTS
# From upstream and control inputs               # Evolves over time                         # Values sent downstream or back to shaft

# 1. Mass Flow Rate          (m_dot)             # Pressure Ratio                            # Total pressure at output (P0_out)
# 2. Rotations per Minute    (N)                 # Temperature rise                          # Total temperature at output   (T0_out)
# 3. Inlet Total Pressure    (P0_in)             # Stability (Surge margin)                  # Mass flow rate (May be smaller than input if choking occurs)
# 4. Inlet Total Temperature (T0_in)             # Efficiency (could be looked up)           # Efficiency
                                                                                             # Compressor work required
                                                                                             # Torque demand
function [P0_out, T0_out, m_dot, PowReq_comp ] = compressor(m_dot, N, P0_in, T0_in)
  # Inlet
  r_tip_in = 0.2262;      #[m]
  r_root_in = 0.1131;     #[m]
  
  r_mid = 0.1697;         #[m]
  
  # Outlet
  r_tip_out = 0.1903;     #[m]
  r_root_out = 0.1491;    #[m]
  
  
  # STAGE 1
  # Using velocity triangles, find the velocities and angles
  # From this we can get the power required by the stage
  lambda = 0.98;
  U = 2 * pi * N * r_mid
  
  
  # Cw1 = 0  [Whirl component at inlet (No IGVs)] 
  Cw1 = 0;
  dCw = (Cp * dT) / (lambda * U);
  
  
  
  
end