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
function [P0_out, T0_out, m_dot, PowReq_comp ] = compressor(m_dot, N, P0_in, T0_in, Cp, Ca1)
  # Inlet
  r_tip_in = 0.2262;      #[m]
  r_root_in = 0.1131;     #[m]
  
  r_mid = 0.1697;         #[m]
  
  # Outlet
  r_tip_out = 0.1903;     #[m]
  r_root_out = 0.1491;    #[m]
  
  [PowReq_comp_st1, T0_out, P0_out, isStable] = compressor_stage(m_dot, T0_in, P0_in, Cp, Ca1, N, r_mid);
  PowReq_comp = PowReq_comp_st1;
    
end


# STAGE 1
# Using velocity triangles, find the velocities and angles
# From this we can get the power required by the stage
function [PowReq_comp_st1, T0_out, P0_out, isStable] = compressor_stage(m_dot, T0_in, P0_in, Cp, Ca, N, r_mid)
    
    lambda = 0.98;
    n = 0.90;                  # Isentropic efficiency
    Sp_heat_ratio = 1.4;       # For Air (diatomic)
    U = 2 * pi * N * r_mid;
     
    # Change stage temperature
    # The change in temperature should be calculated via iterations
    # Use relaxation to avoid jumping/oscillating of values
    # dT = lambda * U * Ca * (tan(beta1) - tan(beta2)) / Cp;
    dT = 20;
    
    # Cw1 = 0  [Whirl component at inlet (No IGVs)] 
    Cw1 = 0;
    dCw = (Cp * dT) / (lambda * U);
    Cw2 = Cw1 + dCw;
    
    # Check the aerodynamic loading on the stage
    # Use de Haller's number
    beta1 = atan2(U, Ca);           # Angle in radians
    beta2 = atan2(U - Cw2, Ca);
    
    printf("Beta 2: %f\n", beta2);
    
    # This should be read by a sensor
    # dT is statisc so this value is not realistic
    T0_out = T0_in + dT;
    
    rotor_defl = beta2 - beta1;
    
    # Checking aerodynamic loading
    # V2 / V1 should not be less than 0.72
    V2 = Ca/cos(beta2);
    V1 = Ca/cos(beta1);
    
    
        
    deHaller = V2 / V1;
    
    printf("De Haller value: %f\n", deHaller);
    
    if deHaller < 0.72
      printf("⚠️ Warning: Possible stall! Stage unstable!");
      isStable = false;
    else
      printf("✅ Stage Stable!")
      isStable = true;
    endif
    
    # Use Isentropic relation of pressure and temperature to find stage exit pressure
    # PR = (P0_out / P0_in)
    PR = (1 + n * (dT / T0_in))^(Sp_heat_ratio / (Sp_heat_ratio - 1));
    P0_out = PR * P0_in;
    
    PowReq_comp_st1 = m_dot * U * dCw;  
    
endfunction