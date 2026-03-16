%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Checks the data correlation of the points extracted from the step
% response database (results structure)
%
% OUTPUT FOLDER: N/A
%==========================================================================

% results = [Mp, t02, t05, t08, nu, zeta];
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')

Mp   = results(:, 1);
t02  = results(:, 2);
t05  = results(:, 3);
t08  = results(:, 4);
nu   = results(:, 5);
zeta = results(:, 6);
tau = t08./t02;

data_for_corr = [Mp, t02, t05, t08, tau, nu, zeta];
var_names = {'Mp', 't02', 't05', 't08', 'tau', 'nu', 'zeta'};

R = corrcoef(data_for_corr);

T_corr = array2table(R, 'VariableNames', var_names, 'RowNames', var_names);
disp('--- Matriz de Correlação ---');
disp(T_corr);


% fprintf('\n### Correlation Matrix (Pearson)\n\n');
% fprintf('| | %s |\n', strjoin(var_names, ' | '));
% fprintf('| :--- | %s |\n', repmat(':---: | ', 1, length(var_names)));
% 
% for i = 1:size(R, 1)
%     fprintf('| **%s** | %s |\n', var_names{i}, strjoin(string(round(R(i,:), 4)), ' | '));
% end