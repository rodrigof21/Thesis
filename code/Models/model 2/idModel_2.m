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

% % results = [Mp, t02, t05, t08, nu, zeta];
%load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')

% filteredPoints (better alternative to results)
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

% Mp   = results(:, 1); % remove if working with filteredPoints
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);

% tau1 = t02./t05;
% tau2 = t05./t08;
tau = t08./t02;

% nu = f(t02, t05, t08)
X_nu = [log(tau), log(t05)];
Y_nu = nu;
fit_nu = fit(X_nu, Y_nu, 'poly33');

% zeta = f(t05, nu)
X_zeta = [t05, nu];
fit_zeta = fit(X_zeta, zeta, 'poly22');

idModel2 = struct();
idModel2.step1 = fit_nu;
idModel2.step2 = fit_zeta;


% --- Gráfico 1: Ajuste de Nu = f(tau1, tau2) ---
figure('Name', 'Ajuste da Ordem Fracionária (\nu)', 'Color', 'w');

% Plot da superfície de fit semitransparente
plot(fit_nu, X_nu, nu); 

% Melhorar o visual
xlabel('\tau_1 (t_{0.2}/t_{0.5})');
ylabel('\tau_2 (t_{0.5}/t_{0.8})');
zlabel('\nu (Ordem)');
title('Superfície de Identificação de \nu');
grid on;
% Ajustar a vista para ver bem a curvatura
view(-45, 15); 
colormap jet; % Cor para a superfície
alpha(0.7);   % Transparência para ver os pontos por baixo

% --- Gráfico 2: Ajuste de Zeta = f(t05, nu) ---
figure('Name', 'Ajuste do Amortecimento (\zeta)', 'Color', 'w');

% Plot da superfície de fit
plot(fit_zeta, X_zeta, zeta);

% Melhorar o visual
xlabel('t_{0.5} (s)');
ylabel('\nu (Ordem)');
zlabel('\zeta (Amortecimento)');
title('Superfície de Identificação de \zeta');
grid on;
% Ajustar a vista
view(135, 15);
colormap parula; % Cor diferente para distinguir
alpha(0.7);