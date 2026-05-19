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

% filteredPoints (better alternative to results)
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

% points data
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);
t07  = results(:, 6);
Mp   = results(:, 7);
tp   = results(:, 8);
t01  = results(:, 9);


idx = nu > 0.6 & Mp > 0.00001;

tau1 = (t05./t02);
tau2 = t08./t02;
tau3 = t02./t07;
tau4 = t01./t02;
tau5 = (t08-t05)./(t05-t02);
tau6 = tp./t01;

tau1 = tau1(idx);
tau2 = tau2(idx);
tau3 = tau3(idx);
tau4 = tau4(idx);
tau5 = tau5(idx);
tau6 = tau6(idx);
Mp = Mp(idx);
zeta = zeta(idx);

data_for_corr = [tau1, tau2, tau3, tau4, tau5, tau6, Mp, zeta, tp(idx), nu(idx)];
var_names = {'tau1', 'tau2', 'tau3', 'tau4', 'tau5', 'tau6', 'Mp', 'zeta', 'tp', 'nu'};

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