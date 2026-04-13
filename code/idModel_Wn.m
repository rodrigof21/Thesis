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

% 1. Prepare the data (Ensure they are column vectors)
x = (nu); 
y = (zeta); 
z = log(a);

% 2. Set up fittype and options
% 'poly33' creates: a = p00 + p10*nu + p01*zeta + p20*nu^2 + p11*nu*zeta... up to 3rd degree
%ft = fittype('rat22');

% 3. Fit the model to the data
[fitresult, gof] = fit([x, y], z, 'poly44');

% 4. Display the results
fprintf('\n--- Surface Fit Results ---\n');
disp(fitresult);
fprintf('Goodness of Fit (R-squared): %.4f\n', gof.rsquare);

% 5. Plot the result to compare with your data
figure('Name', 'Thesis: Surface Fit Validation');
h = plot(fitresult, [x, y], z);
xlabel('\nu (Fractional Order)');
ylabel('\zeta (Damping)');
zlabel('Scaling Factor (a)');
title(sprintf('Polynomial Fit (R^2 = %.3f)', gof.rsquare));
grid on;