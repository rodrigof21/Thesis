%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Third ID model, this time starting by zeta, that highly correlates to the
% times measured in extract points.
%
% OUTPUT FOLDER: Models/models3
%==========================================================================


% results = [Mp, t02, t05, t08, nu, zeta];
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')

Mp   = results(:, 1);
t02  = results(:, 2);
t05  = results(:, 3);
t08  = results(:, 4);
nu   = results(:, 5);
zeta = results(:, 6);

tau1 = t02./t05;
tau2 = t05./t08;
tau = t08./t02;

% zeta = f(t05, t08)
X_zeta = [t05, t08];
Y_zeta = zeta;
fit_zeta = fit(X_zeta, Y_zeta, 'poly22');

% nu = f(t02, zeta)
X_nu = [t02, zeta];
fit_nu = fit(X_nu, nu, 'poly22');

idModel3 = struct();
idModel3.step1 = fit_zeta;
idModel3.step2 = fit_nu;


visibility = 'on';
% --- Plot 1: nu ---
figure('Name', 'damping fit (\zeta)', 'Color', 'w', 'Visible',visibility);
plot(fit_zeta, X_zeta, Y_zeta); 

% Configurations
xlabel('(t_{0.5})');
ylabel('(t_{0.8})');
zlabel('\zeta (damping)');
title('damping ID surface \nu');
grid on;
% Ajustar a vista para ver bem a curvatura
view(-45, 15); 
colormap jet; % Cor para a superfície
alpha(0.7);   % Transparência para ver os pontos por baixo

% --- Plot 2: zeta ---
figure('Name', 'order fit (\nu)', 'Color', 'w', 'Visible',visibility);
plot(fit_nu, X_nu, nu);

% Configurations
xlabel('t_{0.2} (s)');
ylabel('\zeta');
zlabel('\nu (order)');
title('order ID surface \zeta');
grid on;
% Ajustar a vista
view(135, 15);
colormap parula; % Cor diferente para distinguir
alpha(0.7);


% --- Print Equations in LaTeX (Clean format) ---
fprintf('\n--- Equations for Thesis (LaTeX) ---\n');

% Equação para nu
f_nu = fit_nu;
c_nu = coeffvalues(f_nu);
n_nu = coeffnames(f_nu);
str_nu = formula(f_nu);
for i = 1:length(c_nu)
    str_nu = strrep(str_nu, n_nu{i}, sprintf('%.4f', c_nu(i)));
end
str_nu = strrep(str_nu, 'x', '\tau');
str_nu = strrep(str_nu, 'y', 't_{0.5}');
str_nu = strrep(str_nu, '*', '\cdot '); % Troca * por \cdot
fprintf('$$\\nu(\\tau, t_{0.5}) = %s$$\n', str_nu);

% Equação para zeta
f_ze = fit_zeta;
c_ze = coeffvalues(f_ze);
n_ze = coeffnames(f_ze);
str_ze = formula(f_ze);
for i = 1:length(c_ze)
    str_ze = strrep(str_ze, n_ze{i}, sprintf('%.4f', c_ze(i)));
end
str_ze = strrep(str_ze, 'x', 't_{0.5}');
str_ze = strrep(str_ze, 'y', '\nu');
str_ze = strrep(str_ze, '*', '\cdot '); % Troca * por \cdot
fprintf('$$\\zeta(t_{0.5}, \\nu) = %s$$\n', str_ze);