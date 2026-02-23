%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRTIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% The goal is to plot the stability chart zonsidering zeta and nu for the
% various systems like in the bibliography
% Based on: Hmed et al. (2015) - "Stability and resonance conditions..."
%
%
% OUTPUT FOLDER: results\stabilityChart
%==========================================================================

close all;

% 1. Parameters and Grid Setup
nu_vec = linspace(0.01, 2, 300);    % nu range (x-axis)
zeta_vec = linspace(-1, 5, 300);   % zeta range (y-axis)
[NU, ZETA] = meshgrid(nu_vec, zeta_vec);

% Initialize the classification matrix
% 1: Stable, no peaks | 2: Stable, 1 peak | 3: Unstable, 1 peak | 4: Unstable, no peak
Regions = zeros(size(NU));

% 2. Main Computation Loop
% We normalize by setting wn = 1
for i = 1:numel(NU)
    nu = NU(i);
    zeta = ZETA(i);
    
    % --- Stability Boundary Calculation ---
    % Analytical boundary from Eq. (2.2) of Hmed et al.
    % The system is stable if zeta > zeta_osc
    zeta_osc = -sin((nu + 1) * pi/2) / (2 * sin(nu * pi/2));
    is_stable = (zeta > zeta_osc);
    
    % --- Resonance Detection ---
    % Evaluate the magnitude of the frequency response
    w = logspace(-2, 2, 400); % Frequency vector
    s = 1j * w;
    G_jw = 1 ./ (s.^(nu+1) + 2*zeta*s.^nu + 1);
    mag = abs(G_jw);
    
    % A peak exists if the maximum magnitude is greater than the DC gain (G(0)=1)
    has_peak = max(mag) > 1.001; 
    
    % 3. Categorization
    if is_stable && ~has_peak
        Regions(i) = 1; % Cyan
    elseif is_stable && has_peak
        Regions(i) = 2; % Blue
    elseif ~is_stable && has_peak
        Regions(i) = 3; % Yellow/Orange
    else
        Regions(i) = 4; % Green
    end
end

% 4. Visualization
figure('Color', 'w', 'Position', [100 100 850 600]);

% Plot the filled regions
[~, h] = contourf(NU, ZETA, Regions, [1 2 3 4]);
set(h, 'LineColor', 'none');
hold on;

% Plot the analytical black stability boundary line
%zeta_osc_line = -sin((nu_vec + 1) * pi/2) ./ (2 * sin(nu_vec * pi/2));
%plot(nu_vec, zeta_osc_line, 'k', 'LineWidth', 2.5);

% Define custom colors matching the user image
% Regions: [Cyan, Blue, Orange/Yellow, Green]
myMap = [0.2, 0.85, 0.95;  % Region 1
         0.2, 0.45, 1.0;   % Region 2
         1.0, 0.75, 0.15;  % Region 3
         0.2, 0.70, 0.3];  % Region 4
colormap(myMap);

% Formatting the plot
xlabel('\nu', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('\zeta', 'FontSize', 14, 'FontWeight', 'bold');
title('Stability and Resonance Regions for Non-Commensurate System', 'FontSize', 12);
axis([0 2 -1 5]);
grid on;

% Add Text Labels
text(0.5, 3.5, 'stable, no peaks', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(1.5, 3.5, 'stable, 1 peak', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(1.5, -0.5, 'unstable, 1 peak', 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', 'w');
text(0.5, -0.5, 'unstable, no peaks', 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'Color', 'w');

% Optional: Draw vertical line at nu = 1 to show standard 2nd order case
line([1 1], [-1 5], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');