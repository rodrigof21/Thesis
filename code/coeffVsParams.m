%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Plots the coefficients a taken from [[effectsOfWn.m]] and plots them
% against nu and zeta (same values as the mention script)
%
%
% OUTPUT FOLDER: results/coeffVsParams
%==========================================================================

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\a_coeffs.mat')
nu_init = 0.1:0.2:2;
zeta_init = 0.0:0.2:2; 
[nu_st, zeta_st] = filterUnstablePairs(nu_init, zeta_init);

% Create the empty grid (filled with NaN so unstable areas stay blank)
[NU, ZETA] = meshgrid(nu_init, zeta_init);
A_grid = nan(size(NU));


for k = 1:length(a)
    % Find which row and column in the grid corresponds to this stable pair
    row = find(zeta_init == zeta_st(k));
    col = find(nu_init == nu_st(k));
    
    A_grid(row, col) = a(k);
end

figure;
surf(NU, ZETA, A_grid);
% xlabel('\nu'); ylabel('\zeta'); zlabel('Constant a');
% title('Scaling Factor Surface');
% shading interp; % Optional: makes the surface look smooth
% colorbar;

% Styling
s.EdgeColor = 'none';      % Remove grid lines for a cleaner look
shading interp;            % Interpolate colors between points
colormap(parula);          % Professional color scale
colorbar;                  % Adds a scale for 'a' values

% Labels
xlabel('\nu (Fractional Order)');
ylabel('\zeta (Damping)');
zlabel('Scaling Factor (a)');
title('Relationship between \omega_n and t_{05}: \omega_n = a / t_{05}');

% Adjust the view to highlight the stability boundary "cliff"
view(140, 30); 
grid on;