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
tau2 = t05./t02;


% halfpoint = 1.11;
% idx0 = nu <= halfpoint;
% idx1 = nu > halfpoint;
% Y_nu0 = nu(idx0);
% Y_nu1 = nu(idx1);


% nu
X_nu = [tau, nu];
Y_nu = tau2;
[fit_tau2, gof_tau2] = fit(X_nu, Y_nu, 'poly22');
fprintf('R-squared para Nu0: %.4f\n', gof_tau2.rsquare);


% zeta
X_zeta = [log(tau2), nu];
Y_zeta = zeta;
[fit_zeta, gof_zeta] = fit(X_zeta, zeta, 'poly44');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);



%% Invert and create the Model

coeffs = coeffvalues(fit_tau2);

p00 = coeffs(1); 
p10 = coeffs(2); 
p01 = coeffs(3);
p20 = coeffs(4); 
p11 = coeffs(5); 
p02 = coeffs(6);

fit_nu = @(t1, t2) ...
    ( - (p01 + p11.*t1) + sqrt( (p01 + p11.*t1).^2 - 4.*p02.*((p00 + p10.*t1 + p20.*t1.^2) - t2) ) ) ./ (2.*p02);


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

visibility = 'off';

% 1. Create a grid of points
[T1, T2] = meshgrid(linspace(min(tau), max(tau), 50), ...
                    linspace(min(tau2), max(tau2), 50));

% 2. Evaluate the inverted function
% Note: Using arrayfun if your fit_nu isn't fully vectorized, 
% but the formula we built is vectorized, so this works:
NU_SURFACE = real(fit_nu(T1, T2));

% 3. Plot
figure('Name', 'Model Validation');
surf(T1, T2, NU_SURFACE, 'EdgeColor', 'none', 'FaceAlpha', 0.7);
hold on;

% 4. Overlay the original data points (Real values)
plot3(tau, tau2, nu, 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'r');

grid on;
xlabel('\tau_1');
ylabel('\tau_2');
zlabel('\nu');
legend('Analytical Inversion (fit\_nu)', 'Real Data Points');
view(-45, 20);


% --- Gráfico 1.0: Ajuste de Nu = f(tau1, tau2) ---
figure('Name', 'Ajuste da Ordem Fracionária (\nu) 0', 'Color', 'w', 'Visible',visibility);

% Plot da superfície 
plot(fit_tau2, X_nu, Y_nu); 

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



%% GEMINI EXPRESSION GENERATOR

clc;

% 1. Extrair coeficientes do fit_tau2
c = coeffvalues(fit_tau2);
p00 = c(1); p10 = c(2); p01 = c(3);
p20 = c(4); p11 = c(5); p02 = c(6);

% 2. Gerar a string LaTeX para o Obsidian
% Note: Usamos num2str com precisão para manter o rigor
formula_md = sprintf('$$\\nu = \\frac{-(%.4f + %.4f\\tau_1) \\pm \\sqrt{(%.4f + %.4f\\tau_1)^2 - 4(%.4f)(%.4f + %.4f\\tau_1 + %.4f\\tau_1^2 - \\tau_2)}}{2(%.4f)}$$', ...
    p01, p11, p01, p11, p02, p00, p10, p20, p02);

% 3. Exibir no Command Window para copiar
disp('--- Copia para o Obsidian abaixo desta linha ---')
disp(formula_md)
disp('---')

formula_direta = sprintf('$$\\tau_2 = %.6f + (%.6f)\\tau_1 + (%.6f)\\nu + (%.6f)\\tau_1^2 + (%.6f)\\tau_1\\nu + (%.6f)\\nu^2$$', ...
    p00, p10, p01, p20, p11, p02);

disp('--- Copia para o Obsidian ---')
disp(formula_direta)
disp('---')