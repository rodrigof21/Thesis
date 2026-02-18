%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% The goal is to plot various graphs comparing the points extracted in
% [[extractPoints]] to evaluate how they relate and which points to use
%
% OUTPUT FOLDER: results\comparePoints
%==========================================================================

outputFolder = 'results/comparePoints';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% points db
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\extractPoints\Points.mat');
% data_storage db
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat')

sys = fieldnames(points);
count = 1;


% Tratamento de dados
Mp = zeros(length(sys), 1);
t05 = zeros(length(sys), 1);
nu = zeros(length(sys), 1);
zeta = zeros(length(sys), 1);

for k = 1:length(sys)
    
    current = sys{k};
    data = points.(current);

    Mp(k) = data.Mp;
    t05(k) = data.t05;
    nu(k) = data.nu;
    zeta(k) = data.zeta;
end

results = [Mp t05 nu zeta];

uni_zeta = unique(zeta);
uni_nu = unique(nu);


% Mp vs nu

figure;
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

   plot(nu_plot, mp_plot, '-o', 'DisplayName', sprintf('\\zeta = %.1f', z));
end

xlabel('Fractional Order (\\nu)');
ylabel('Overshoot (M_p)');
title('Mp vs. nu');
legend('Location', 'eastoutside');


% zeta vs. t05

figure;
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

   plot(zeta_plot, t05_plot, '-o', 'DisplayName', sprintf('\\nu = %.1f', v));
end

ylabel('t05');
xlabel('Zeta');
title('\\t_{0,5} vs zeta');
legend('Location', 'eastoutside');