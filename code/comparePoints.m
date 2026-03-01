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
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

visibility = 'off';

% points db
%load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\extractPoints\Points.mat');
% validated points db
%load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\validatedPoints\validated_points_database.mat')
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\validatedPoints\double_validated_points.mat')

sys = fieldnames(validated_results);
count = 1;

% Tratamento de dados
Mp = zeros(length(sys), 1);
t05 = zeros(length(sys), 1);
nu = zeros(length(sys), 1);
zeta = zeros(length(sys), 1);

for k = 1:length(sys)
    
    current = sys{k};
    data = validated_results.(current);

    Mp(k) = data.Mp_rel;
    t05(k) = data.t05;
    nu(k) = data.nu;
    zeta(k) = data.zeta;
end

results = [Mp t05 nu zeta];

uni_zeta = unique(zeta);
uni_nu = unique(nu);


% Mp vs nu

h1 = figure('Visible',visibility);
hold on;
grid on;

for i = 1:length(uni_zeta)
   
   % extract data for each value of zeta
   z = uni_zeta(i);
   idx = results(:, 4) == z;
   plot_data = results(idx, :);

   % sort by nu just to make sure
   [~, idx_sort] = sort(plot_data(:, 3));
   nu_plot = plot_data(idx_sort, 3);
   mp_plot = plot_data(idx_sort, 1);

   plot(mp_plot, nu_plot, '-o', 'DisplayName', sprintf('\\zeta = %.1f', z));
end

ylabel('Fractional Order (\\nu)');
xlabel('Overshoot (M_p)');
title('nu vs. Mp');
legend('Location', 'eastoutside');
saveas(h1, fullfile(outputFolder, 'nu_vs_Mp'));

% zeta vs. t05

h2 = figure('Visible',visibility);
hold on;
grid on;

for i = 1:length(uni_nu)
   
   % extract data for each value of nu
   v = uni_nu(i);
   idx = results(:, 3) == v;
   plot_data = results(idx, :);

   % sort by zeta just to make sure
   [~, idx_sort] = sort(plot_data(:, 4));
   t05_plot = plot_data(idx_sort, 2);
   zeta_plot = plot_data(idx_sort, 4);

   plot(t05_plot, zeta_plot, '-o', 'DisplayName', sprintf('\\nu = %.1f', v));
end


xlabel('t05');
ylabel('Zeta');
title('zeta vs t_{0,5}');
legend('Location', 'eastoutside');
saveas(h2, fullfile(outputFolder, 'zeta_vs_t05'));


% nu vs. t05 
h3 = figure('Visible',visibility);
hold on;
grid on;
for i = 1:length(uni_zeta)
   z = uni_zeta(i);
   idx = results(:, 4) == z;
   plot_data = results(idx, :);
   
   % We want t05 on X and nu on Y
   [t05_sorted, idx_sort] = sort(plot_data(:, 2));
   nu_plot = plot_data(idx_sort, 3);
   
   plot(t05_sorted, nu_plot, '-o', 'DisplayName', sprintf('\\zeta = %.1f', z));
end
xlabel('Rise Time (t_{0.5})'); % What we know
ylabel('Fractional Order (\nu)'); % What we want to find
title('\nu vs. t_{0.5}');
legend('Location', 'eastoutside');
saveas(h3, fullfile(outputFolder, 'nu_vs_t05'));

% zeta vs. Mp 
h4 = figure('Visible',visibility);
hold on;
grid on;
for i = 1:length(uni_nu)
   v = uni_nu(i);
   idx = results(:, 3) == v;
   plot_data = results(idx, :);
   
   % We want Mp on X and zeta on Y
   [mp_sorted, idx_sort] = sort(plot_data(:, 1));
   zeta_plot = plot_data(idx_sort, 4);
   
   plot(mp_sorted, zeta_plot, '-o', 'DisplayName', sprintf('\\nu = %.1f', v));
end
xlabel('Overshoot (M_p)'); % What we know
ylabel('Damping (\zeta)'); % What we want to find
title('\zeta vs. M_p');
legend('Location', 'eastoutside');
saveas(h4, fullfile(outputFolder, 'zeta_vs_Mp'));


%% Data structure save
CalibrationData = struct();

% 1. nu vs. Mp 
for i = 1:length(uni_zeta)
   z = uni_zeta(i);
   idx = results(:, 4) == z;
   plot_data = results(idx, :);
   
   % Ordenar pelo X (Mp)
   [mp_sorted, idx_sort] = sort(plot_data(:, 1));
   
   CalibrationData.nu_vs_Mp(i).zeta = z;
   CalibrationData.nu_vs_Mp(i).x_Mp = mp_sorted;
   CalibrationData.nu_vs_Mp(i).y_nu = plot_data(idx_sort, 3);
end

% 2. zeta vs. t05 
for i = 1:length(uni_nu)
   v = uni_nu(i);
   idx = results(:, 3) == v;
   plot_data = results(idx, :);
   
   % Ordenar pelo X (t05)
   [t05_sorted, idx_sort] = sort(plot_data(:, 2));
   
   CalibrationData.zeta_vs_t05(i).nu = v;
   CalibrationData.zeta_vs_t05(i).x_t05 = t05_sorted;
   CalibrationData.zeta_vs_t05(i).y_zeta = plot_data(idx_sort, 4);
end

% 3. zeta vs. Mp 
for i = 1:length(uni_nu)
   v = uni_nu(i);
   idx = results(:, 3) == v;
   plot_data = results(idx, :);
   
   % Ordenar pelo X (Mp)
   [mp_sorted, idx_sort] = sort(plot_data(:, 1));
   
   CalibrationData.zeta_vs_Mp(i).nu = v;
   CalibrationData.zeta_vs_Mp(i).x_Mp = mp_sorted;
   CalibrationData.zeta_vs_Mp(i).y_zeta = plot_data(idx_sort, 4);
end

% 4. nu vs. t05 
for i = 1:length(uni_zeta)
   z = uni_zeta(i);
   idx = results(:, 4) == z;
   plot_data = results(idx, :);
   
   % Ordenar pelo X (t05)
   [t05_sorted, idx_sort] = sort(plot_data(:, 2));
   
   CalibrationData.nu_vs_t05(i).zeta = z;
   CalibrationData.nu_vs_t05(i).x_t05 = t05_sorted;
   CalibrationData.nu_vs_t05(i).y_nu = plot_data(idx_sort, 3);
end

% Save structure file
save(fullfile(outputFolder, 'CalibrationData.mat'), 'CalibrationData');
fprintf('Calibration data saved in: %s\n', outputFolder);