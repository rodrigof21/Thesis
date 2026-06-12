%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Curve fitting a model to identify Wn
%
% OUTPUT FOLDER: results\effectsOfWn_coefficients
%==========================================================================

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\wnid_data.mat')

a = wnid_data(:, 1);
nu = wnid_data(:, 2);
zeta = wnid_data(:, 3);


x = (nu); 
y = (zeta); 
z = log(a);

[fit_wn, gof] = fit([x, y], z, 'poly22');



% 4. Display the results
fprintf('\n--- Surface Fit Results ---\n');
disp(fit_wn);
fprintf('Goodness of Fit (R-squared): %.4f\n', gof.rsquare);

% 5. Plot the result to compare with your data
figure('Name', 'Thesis: Surface Fit Validation');
h = plot(fit_wn, [x, y], z);
xlabel('\nu (Fractional Order)');
ylabel('\zeta (Damping)');
zlabel('Scaling Factor (a)');
title('Identification Surface for \omega_n');
colormap turbo
grid on;