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

function [ N, w_new, T_net ] = shaft(T_turb, PowReq_comp, PowProd_turb, T_acc, state, I, Cf, Kw, dt)
  # This gives use the net Torque
  # If T_net is +ve shaft is accelerating
  # If T_net is -ve shaft is decelerating 
  # If T_net is zero, shaft is in equilibrium
  
  w_old = state.w;
  
  T_comp = PowReq_comp / max(w_old, 1e-6);
  T_frict = Cf * w_old;
  T_wind = Kw * w_old^2;
  
  PowNet_shaft = PowProd_turb - PowReq_comp - Pow_loss;
  
  T_net = T_turb - T_comp - T_wind - T_frict - T_acc;
  
  # Newton's Second Law of Rotation
  dw = T_net / I;

  w_new = w_old + dw;
  
  state.w = w_new;
  
  N = (w_new * 60) / (2 * pi);
  
end