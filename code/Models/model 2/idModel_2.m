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
t09  = results(:, 6);
t95  = results(:, 7);
t99  = results(:, 8);


idx = zeta>=2 & nu >= 1;

tau = t08./t02;
tau2 = t05./t02;
tau3 = t08./t05;


% nu
X_nu = [log(tau(idx)), log(tau2(idx))];
Y_nu = nu(idx);
[fit_nu, gof_nu] = fit(X_nu, Y_nu, 'poly44');
fprintf('R-squared para Nu0: %.4f\n', gof_nu.rsquare);


% zeta
X_zeta = [log(tau2(idx)), (nu(idx))];
Y_zeta = zeta(idx);
[fit_zeta, gof_zeta] = fit(X_zeta, Y_zeta, 'poly44');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);



%% Invert and create the Model

idModel2 = struct();
idModel2.step1 = fit_nu;
idModel2.step2 = fit_zeta;

% --- save ---
savePath = 'C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\model2.mat';

if ~exist(fileparts(savePath), 'dir')
    mkdir(fileparts(savePath));
end

save(savePath, 'idModel2');
fprintf('Modelo idModel2 gravado com sucesso em: %s\n', savePath);

%% Graphs

visibility = 'on';


% --- Gráfico 1.0: Ajuste de Nu = f(tau1, tau2) ---
figure('Name', 'Ajuste da Ordem Fracionária (\nu) 0', 'Color', 'w', 'Visible',visibility);

% Plot da superfície 
plot(fit_nu, X_nu, Y_nu); 

% Configs
xlabel('\tau_1 (t_{0.2}/t_{0.5})');
ylabel('\tau_2 (t_{0.5}/t_{0.8})');
zlabel('\nu (Ordem)');
title('Superfície de Identificação de \nu_0');
grid on;
view(-45, 15); 
colormap jet;
alpha(0.7);



% --- Gráfico 2: Ajuste de Zeta = f(t05, nu) ---
figure('Name', 'Ajuste do Amortecimento (\zeta)', 'Color', 'w', 'Visible',visibility);

% Plot da superfície de fit
plot(fit_zeta, X_zeta, Y_zeta);

% Configs
xlabel('t_{0.5} (s)');
ylabel('\nu (Ordem)');
zlabel('\zeta (Amortecimento)');
title('Superfície de Identificação de \zeta');
grid on;
view(135, 15);
colormap parula;
alpha(0.7);


