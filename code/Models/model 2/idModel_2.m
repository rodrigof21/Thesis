%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Second try at a identification model. nu = f(tau1, tau2)
%
% OUTPUT FOLDER: Models\model2
%==========================================================================

clc;

% % results = [Mp, t02, t05, t08, nu, zeta];
%load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')

% filteredPoints (better alternative to results)
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

% points data
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);
Mp   = results(:, 6);
tp   = results(:, 7);


tau = t08./t02;
tau2 = Mp;

halfpoint = 1.12;
idx0 = nu < halfpoint;
idx1 = nu >= halfpoint;

Y_nu0 = nu(idx0);
Y_nu1 = nu(idx1);
    

% nu0
X_nu0 = [log(tau(idx0)), log(tau2(idx0))];
[fit_nu0, gof_nu0] = fit(X_nu0, Y_nu0, 'poly33');
fprintf('R-squared para Nu0: %.4f\n', gof_nu0.rsquare);

% nu1
X_nu1 = [log(tau(idx1)), log(tau2(idx1))];
[fit_nu1, gof_nu1] = fit(X_nu1, Y_nu1, 'poly33');
fprintf('R-squared para Nu1: %.4f\n', gof_nu1.rsquare);


% zeta
X_zeta = [log(tau), nu];
[fit_zeta, gof_zeta] = fit(X_zeta, zeta, 'poly33');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);


idModel2 = struct();
idModel2.step1 = fit_nu0;
idModel2.step2 = fit_nu1;
idModel2.step3 = fit_zeta;

visibility = 'off';

figure('Name', 'ID Points', 'Visible', 'off');
plot3(tau, tau2, zeta, '.')
grid on

% --- Gráfico 1.0: Ajuste de Nu = f(tau1, tau2) ---
figure('Name', 'Ajuste da Ordem Fracionária (\nu) 0', 'Color', 'w', 'Visible',visibility);

% Plot da superfície 
plot(fit_nu0, X_nu0, Y_nu0); 

% Configs
xlabel('\tau_1 (t_{0.2}/t_{0.5})');
ylabel('\tau_2 (t_{0.5}/t_{0.8})');
zlabel('\nu (Ordem)');
title('Superfície de Identificação de \nu_0');
grid on;
view(-45, 15); 
colormap jet;
alpha(0.7);

% --- Gráfico 1.1: Ajuste de Nu = f(tau1, tau2) ---
figure('Name', 'Ajuste da Ordem Fracionária (\nu) 1', 'Color', 'w', 'Visible',visibility);

% Plot da superfície 
plot(fit_nu1, X_nu1, Y_nu1); 

% Configs
xlabel('\tau_1 (t_{0.2}/t_{0.5})');
ylabel('\tau_2 (t_{0.5}/t_{0.8})');
zlabel('\nu (Ordem)');
title('Superfície de Identificação de \nu_1');
grid on;
view(-45, 15); 
colormap jet;
alpha(0.7);

% --- Gráfico 2: Ajuste de Zeta = f(t05, nu) ---
figure('Name', 'Ajuste do Amortecimento (\zeta)', 'Color', 'w', 'Visible',visibility);

% Plot da superfície de fit
plot(fit_zeta, X_zeta, zeta);

% Configs
xlabel('t_{0.5} (s)');
ylabel('\nu (Ordem)');
zlabel('\zeta (Amortecimento)');
title('Superfície de Identificação de \zeta');
grid on;
view(135, 15);
colormap parula;
alpha(0.7);


% --- save ---
savePath = 'C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\model2.mat';

if ~exist(fileparts(savePath), 'dir')
    mkdir(fileparts(savePath));
end

save(savePath, 'idModel2');
%fprintf('Modelo idModel2 gravado com sucesso em: %s\n', savePath);


