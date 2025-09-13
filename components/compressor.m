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
                                                                                             # Torque deman
function [P0_out, T0_out, m_dot, PowReq_comp ] = compressor(m_dot, N, P0_in, T0_in)
  
  
  
  
end