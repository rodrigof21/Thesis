%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% First test at fitting a curve to the data taken in the
% [[comparePoints.m]] file. uses the structure saved in that script
%
% OUTPUT FOLDER: results/curveFit_test
%==========================================================================

outputFolder = 'results/curveFit_test';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end


load('results/comparePoints/CalibrationData.mat');

idx = 6;

% Data
x = CalibrationData.nu_vs_Mp(idx).x_Mp;
y = CalibrationData.nu_vs_Mp(idx).y_nu;
zeta = CalibrationData.nu_vs_Mp(idx).zeta;

% val(x) = a*x^b+c
f_power = fit(x, y, 'power2');
coeffs = coeffvalues(f_power);

% plots
figure;
plot(x, y, 'ko', 'DisplayName', 'data'); 
hold on;
plot(f_power, 'b--');
legend('data', 'power function');
grid on;
xlabel('Mp')
ylabel('\nu')
fprintf(sprintf('a*x^b+c, a=%.2f, b=%.2f, c=%.2f\n', coeffs(1), coeffs(2), coeffs(3)))


% figure, plot(x, y, 'DisplayName', sprintf('z = %.1f', zeta))
% % Styling
% legend('show')
% title('\nu vs. Mp')
% xlabel('Mp')
% ylabel('\nu')
% grid on