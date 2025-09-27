% Building a geometry struct to visualize the annulus area of the inlet

function A = annulus_area(r_hub, r_tip)
  
  % First validate the passed arguments
  A = pi * (r_tip^2 - r_hub^2);
  
end    