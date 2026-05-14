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

% points data
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);
%tp  = results(:, 6);
%Mp  = results(:, 7);


idx = nu > 0.4 & zeta >= 2;

tau = t08./t02;
tau2 = t05./t02;


% nu
X_nu = [log(tau(idx)), log(tau2(idx))];
Y_nu = nu(idx);
[fit_nu, gof_nu] = fit(X_nu, Y_nu, 'poly33');
fprintf('R-squared para Nu0: %.4f\n', gof_nu.rsquare);


% zeta
X_zeta = [log(tau2(idx)), (nu(idx))];
Y_zeta = (zeta(idx));
[fit_zeta, gof_zeta] = fit(X_zeta, Y_zeta, 'poly43');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);


figure, plot3(log(tau(idx)), log(tau2(idx)), nu(idx), '.'), grid on



%% Save the Model

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


%% --- Geração de Equações LaTeX para a Tese ---

% 1. Extração para fit_nu (poly22)
% Ordem: p00, p10, p01, p20, p11, p02
c_n = coeffvalues(fit_nu);
latex_nu = sprintf(['\\nu = %.4f + %.4f \\cdot \\log(\\tau_1) + %.4f \\cdot \\log(\\tau_2) ', ...
                    '+ %.4f \\cdot \\log(\\tau_1)^2 + %.4f \\cdot \\log(\\tau_1)\\log(\\\\tau_2) ', ...
                    '+ %.4f \\cdot \\log(\\tau_2)^2'], ...
                    c_n(1), c_n(2), c_n(3), c_n(4), c_n(5), c_n(6));

% Extrair coeficientes do fit_zeta (poly43)
c = coeffvalues(fit_zeta);

% Definir os nomes das variáveis para o LaTeX
x = '\log(\tau_2)';
y = 'M_p';

% Construção da String LaTeX com valores reais
% Ordem MATLAB poly43: p00, p10, p01, p20, p11, p02, p30, p21, p12, p03, p40, p31, p22, p13
str = sprintf('\\begin{equation}\n\\begin{split}\n\\zeta = \\, & %.4f', c(1)); % p00

% Função auxiliar para formatar cada termo com sinal
formatTerm = @(val, tex) sprintf(' %s %.4f%s', char(43 + 2*(val<0)), abs(val), tex);

% Segunda linha (Ordem 1)
str = [str, ' \n &', formatTerm(c(2), x), formatTerm(c(3), y)]; % p10, p01

% Terceira linha (Ordem 2)
str = [str, ' \n &', formatTerm(c(4), [x '^2']), formatTerm(c(5), [x, y]), formatTerm(c(6), [y '^2'])]; % p20, p11, p02

% Quarta linha (Ordem 3)
str = [str, ' \n &', formatTerm(c(7), [x '^3']), formatTerm(c(8), [x '^2', y]), ...
                    formatTerm(c(9), [x, y '^2']), formatTerm(c(10), [y '^3'])]; % p30, p21, p12, p03

% Quinta linha (Ordem 4)
str = [str, ' \n &', formatTerm(c(11), [x '^4']), formatTerm(c(12), [x '^3', y]), ...
                    formatTerm(c(13), [x '^2', y '^2']), formatTerm(c(14), [x, y '^3'])]; % p40, p31, p22, p13

str = [str, '\n\\end{split}\n\\end{equation}'];

% Output para o Command Window
fprintf('\n--- EQUAÇÃO ZETA PARA O LATEX ---\n\n');
disp(str);

% Mostrar no Command Window
fprintf('\n--- COPIAR PARA LATEX (NU) ---\n%s\n', latex_nu);