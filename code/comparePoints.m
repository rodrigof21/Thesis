%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% The goal is to plot various graphs comparing the points extracted in
% [[extractPoints.m]] and validated in [[validatePoints.m]] 
% to evaluate how they relate and which points to use
%
% OUTPUT FOLDER: results\comparePoints
%==========================================================================

outputFolder = 'results/comparePoints';
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\validatedPoints\double_validated_points.mat')

% 1. Tratamento de Dados
sys = fieldnames(validated_results);
Mp  = cellfun(@(s) validated_results.(s).Mp_rel, sys);
t02 = cellfun(@(s) validated_results.(s).t02, sys);
t05 = cellfun(@(s) validated_results.(s).t05, sys);
t08 = cellfun(@(s) validated_results.(s).t08, sys);
nu  = cellfun(@(s) validated_results.(s).nu, sys);
zeta = cellfun(@(s) validated_results.(s).zeta, sys);

results = [Mp, t02, t05, t08, nu, zeta];
uni_zeta = unique(zeta); uni_nu = unique(nu);
visibility = 'off';
CalibrationData = struct();

% Inicializar as 10 figuras (4 Mp/t05 + 6 para t02 e t08)
h1 = figure('Visible',visibility); hold on; grid on; % nu vs Mp
h2 = figure('Visible',visibility); hold on; grid on; % zeta vs t05
h3 = figure('Visible',visibility); hold on; grid on; % nu vs t05
h4 = figure('Visible',visibility); hold on; grid on; % zeta vs Mp
h5 = figure('Visible',visibility); hold on; grid on; % nu vs t02
h6 = figure('Visible',visibility); hold on; grid on; % nu vs t08
h7 = figure('Visible',visibility); hold on; grid on; % zeta vs t02
h8 = figure('Visible',visibility); hold on; grid on; % zeta vs t08
% h9 = figure('Visible',visibility); hold on; grid on; % nu vs t05 (repetido ou extra)
% h10 = figure('Visible',visibility); hold on; grid on; % zeta vs t05 (repetido ou extra)

% 2. Loop por Zeta Constante (Foco em nu)
for i = 1:length(uni_zeta)
   z = uni_zeta(i);
   idx = results(:, 6) == z;
   data_z = results(idx, :);
   label_z = sprintf('\\zeta = %.1f', z);
   
   % Sorts individuais para garantir linhas contínuas
   [mp_s, im] = sort(data_z(:, 1));
   [t02_s, i2] = sort(data_z(:, 2));
   [t05_s, i5] = sort(data_z(:, 3));
   [t08_s, i8] = sort(data_z(:, 4));

   set(0, 'CurrentFigure', h1); plot(mp_s, data_z(im, 5), '-o', 'DisplayName', label_z);
   set(0, 'CurrentFigure', h3); plot(t05_s, data_z(i5, 5), '-o', 'DisplayName', label_z);
   set(0, 'CurrentFigure', h5); plot(t02_s, data_z(i2, 5), '-o', 'DisplayName', label_z);
   set(0, 'CurrentFigure', h6); plot(t08_s, data_z(i8, 5), '-o', 'DisplayName', label_z);
   CalibrationData.nu_vs_Mp(i)  = struct('zeta', z, 'x_Mp', mp_s,  'y_nu', data_z(im, 5));
   CalibrationData.nu_vs_t02(i) = struct('zeta', z, 'x_t02', t02_s, 'y_nu', data_z(i2, 5));
   CalibrationData.nu_vs_t05(i) = struct('zeta', z, 'x_t05', t05_s, 'y_nu', data_z(i5, 5));
   CalibrationData.nu_vs_t08(i) = struct('zeta', z, 'x_t08', t08_s, 'y_nu', data_z(i8, 5));
end

% 3. Loop por Nu Constante (Foco em zeta)
for i = 1:length(uni_nu)
   v = uni_nu(i);
   idx = results(:, 5) == v;
   data_v = results(idx, :);
   label_v = sprintf('\\nu = %.1f', v);
   
   [t02_s, i2] = sort(data_v(:, 2));
   [t05_s, i5] = sort(data_v(:, 3));
   [t08_s, i8] = sort(data_v(:, 4));
   [mp_s, im] = sort(data_v(:, 1));

   set(0, 'CurrentFigure', h2); plot(t05_s, data_v(i5, 6), '-o', 'DisplayName', label_v);
   set(0, 'CurrentFigure', h4); plot(mp_s, data_v(im, 6), '-o', 'DisplayName', label_v);
   set(0, 'CurrentFigure', h7); plot(t02_s, data_v(i2, 6), '-o', 'DisplayName', label_v);
   set(0, 'CurrentFigure', h8); plot(t08_s, data_v(i8, 6), '-o', 'DisplayName', label_v);
   CalibrationData.zeta_vs_t05(i) = struct('nu', v, 'x_t05', t05_s, 'y_zeta', data_v(i5, 6));
   CalibrationData.zeta_vs_Mp(i)  = struct('nu', v, 'x_Mp', mp_s,  'y_zeta', data_v(im, 6));
   CalibrationData.zeta_vs_t02(i) = struct('nu', v, 'x_t02', t02_s, 'y_zeta', data_v(i2, 6));
   CalibrationData.zeta_vs_t08(i) = struct('nu', v, 'x_t08', t08_s, 'y_zeta', data_v(i8, 6));
end


% 4. Finalização e Gravação Automática
figs = {h1, h2, h3, h4, h5, h6, h7, h8};
titles = {'nu vs Mp', 'zeta vs t05', 'nu vs t05', 'zeta vs Mp', ...
          'nu vs t02', 'nu vs t08', 'zeta vs t02', 'zeta vs t08'};
xlabs = {'M_p', 't_{0.5}', 't_{0.5}', 'M_p', 't_{0.2}', 't_{0.8}', 't_{0.2}', 't_{0.8}'};
ylabs = {'\nu', '\zeta', '\nu', '\zeta', '\nu', '\nu', '\zeta', '\zeta'};
names = {'nu_vs_Mp', 'zeta_vs_t05', 'nu_vs_t05', 'zeta_vs_Mp', ...
         'nu_vs_t02', 'nu_vs_t08', 'zeta_vs_t02', 'zeta_vs_t08'};

for i = 1:length(figs)
    set(0, 'CurrentFigure', figs{i}); 
    title(titles{i}); xlabel(xlabs{i}); ylabel(ylabs{i});
    legend('Location', 'eastoutside');
    saveas(figs{i}, fullfile(outputFolder, names{i}));
end

% Atualizar CalibrationData com os novos tempos para identificação futura
save(fullfile(outputFolder, 'CalibrationData.mat'), 'CalibrationData');
fprintf('Success! 8 individual plots and CalibrationData saved.\n');