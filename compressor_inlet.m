% COMPRESSOR INLET

% Known values
mdot = 136.86;    % Mass Flow Rate [kg/s]
V = 510;          % Inlet air velocity [m/s]
T0 = 288;         % Freestream Temperature [K]
P0 = 101325;      % Freestream pressure [Pa]
R = 287.05;          % Gas constant for air [J/kg.K]

% Inlet area and diameter calculation
A = ( mdot * R * T0 ) / ( P0 * V );   % Area [m^2]
D = sqrt((4 * A) / pi);               % Diameter [m]

% Plot circular intake
theta = linspace(0, 2*pi, 200);   % This just returns row vector with the radian angles

x = (D/2) * cos(theta);
y = (D/2) * sin(theta);

figure;
plot(x, y);
axis equal;
title(sprintf('Compressor Inlet Area (D = %.2f m, A = %.4f m^2)', D, A));
