# SHAFT COMPONENT
# Motion governed ny Newton's second law of Rotation
# Transmits rotational power between compressor and turbine

# INPUTS                      # STATE                               # OUTPUTS
# 1. Turbine Torque           # Angular Velocity, w (rad/s)         # RPM                        [N]
# 2. Compressor Torque        # Angular Displacement, θ (rad)       # Angular Velocity,(rad/s)   [w]
# 3. Windage Torque                                                 
# 4. Friction Torque
# 5. Accessory Torque
# 6. Mass Moment of Inertia (I)

# T_acc = Accessories Torque

function [ N, w_new, T_net ] = shaft(T_turb, T_starter, PowReq_comp, PowProd_turb, T_acc, state, I, Cf, Kw, dt)
  # This gives use the net Torque
  # If T_net is +ve shaft is accelerating
  # If T_net is -ve shaft is decelerating 
  # If T_net is zero, shaft is in equilibrium
  
  w_old = state.w;
  
  # ========================================
  # TORQUE CALCULATIONS
  # ========================================
  
  # Compressor torque requirement
  T_comp = PowReq_comp / max(w_old, 1e-6);
  
  # Friction torque (bearings, seals)
  T_frict = Cf * w_old;
  
  # Windage torque (aerodynamic drag)
  T_wind = Kw * w_old^2;
  
  # ========================================
  # POWER LOSS CALCULATIONS
  # ========================================
  
  # Friction power loss
  Pow_frict = T_frict * w_old;  
  
  # Windage power loss
  Pow_wind = T_wind * w_old;  
  
  # Accessory power loss
  Pow_acc = T_acc * w_old;
  
  # Total mechanical power loss
  Pow_loss = Pow_frict + Pow_wind + Pow_acc;
  
  PowNet_shaft = PowProd_turb - PowReq_comp - Pow_loss;
  
  T_net = T_turb + T_starter - T_comp - T_wind - T_frict - T_acc;
  
  # Newton's Second Law of Rotation
  # Angular acceleration = alpha
  alpha = T_net / I;

  w_new = w_old + alpha * dt;
  
  # Prevent negative speeds
  w_new = max(w_new, 0);
    
  # Converting to RPM
  N = (w_new * 60) / (2 * pi);
  
end