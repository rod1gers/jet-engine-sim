% Building a geometry struct to visualize the annulus area of the inlet

function annulus_geo(x, r_hub, r_tip)
  % Use these arguments to find the annulus geometry struct for plotting
  % x     =   [1xN] axial coordinates at dist m from the shaft
  % r_hub =   [1xN] hub radius (m)
  % r_tip =   [1xN] tip radius (m)
  
  % First validate the passed arguments
  p = inputParser ();
  p.FunctionName = 'annulus_geo';
  p.addRequired('x', @(v) isvector(v) && isreal(v));
  p.addRequired('r_hub', @(v) isvector(v) && isreal(v));
  p.addRequired('r_tip', @(v) isvector(v) && isreal(v));
  
  p.parse(x, r_hub, r_tip);
  
  geo.x = x;
  geo.r_hub = r_hub;
  geo.r_tip = r_tip;
  
  disp('Parsing Results:');
  disp(p.Results);
  
  
  
end    