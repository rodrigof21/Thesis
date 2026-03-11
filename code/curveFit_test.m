%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% First test at fitting curves to the results database from
% [[comparePoints.m]] to make an identification model.
% 1. nu = f(t02, t08, zeta)
% 2. a. b. c = f(zeta) coeficientes do passo 1
% 3. zeta = f(t05, nu)
%
% OUTPUT FOLDER: results/curveFit_test
%==========================================================================

outputFolder = 'results/curveFit_test';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% results = [Mp, t02, t05, t08, nu, zeta];
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')

t02  = results(:, 2);
t05  = results(:, 3);
t08  = results(:, 4);
nu   = results(:, 5);
zeta = results(:, 6);

uni_zeta = unique(zeta);

Model_nu = struct();
Model_pvszeta = struct();
Model_zeta = struct();


% nu = f(t02, t03) by zeta
for i = 1:length(uni_zeta)

    z = uni_zeta(i);
    idx = results(:,6) == z;
    data = results(idx, :);

    t02 = data(:, 2);
    t08 = data(:, 4);
    v = data(:, 5);

    [fitresult, gof] = fit([t02, t08], v, 'poly11');
    
    % h = figure('Visible','off');
    % plot(fitresult, [t02, t08], v);
    % xlabel('t02');
    % ylabel('t08');
    % zlabel('v')
    % title('linear fit')
    % saveas(h, fullfile(outputFolder, 'plot_test'))
    
    Model_nu(i).zeta = z;
    Model_nu(i).p00 = fitresult.p00;
    Model_nu(i).p10 = fitresult.p10;
    Model_nu(i).p01 = fitresult.p01;
    Model_nu(i).R2 = gof.rsquare;
end


% p00, p10, p01 vs. zeta

% 1. Extrair os dados da estrutura Model_nu para vetores
z_axis  = [Model_nu.zeta]';
p00_vec = [Model_nu.p00]';
p10_vec = [Model_nu.p10]';
p01_vec = [Model_nu.p01]';

% 3. Realizar os ajustes e guardar na estrutura
Model_pvszeta.p00_fit = fit(z_axis, p00_vec, 'poly3');
Model_pvszeta.p10_fit = fit(z_axis, p10_vec, 'poly3');
Model_pvszeta.p01_fit = fit(z_axis, p01_vec, 'poly3');

% p00(zeta) = a*zeta^2 + b*zeta + c
Model_pvszeta.coeffs_p00 = coeffvalues(Model_pvszeta.p00_fit); % [a, b, c]
Model_pvszeta.coeffs_p10 = coeffvalues(Model_pvszeta.p10_fit);
Model_pvszeta.coeffs_p01 = coeffvalues(Model_pvszeta.p01_fit);

figure('Name', 'Evolução dos Coeficientes vs Zeta', 'Color', 'w');
subplot(3,1,1); plot(Model_pvszeta.p00_fit, z_axis, p00_vec); ylabel('p00 (\zeta)'); grid on;
subplot(3,1,2); plot(Model_pvszeta.p10_fit, z_axis, p10_vec); ylabel('p10 (\zeta)'); grid on;
subplot(3,1,3); plot(Model_pvszeta.p01_fit, z_axis, p01_vec); ylabel('p01 (\zeta)'); grid on;
xlabel('\zeta (Amortecimento)');


% Model_zeta

[fit_zeta, gof] = fit([t05, nu], zeta, 'poly22');
figure('Color', 'w');
plot(fit_zeta, [results(:,3), results(:,5)], results(:,6));
xlabel('t_{0.5}'); ylabel('\nu'); zlabel('\zeta');
title('Superfície Global de Identificação de \zeta');
grid on; view(-45, 30);
gof.rsquare


Iden