%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Filters the output from [[extractPointsFromDatabase.m]]. clears systems
% where at least one of the t is NaN and converts the structure to a matrix
% that's easier to work with
%
% OUTPUT FOLDER: results\filterPoints
%==========================================================================

outputFolder = 'results/filterPoints';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\extractPoints\Points.mat')


fn = fieldnames(points);
n_sys = length(fn);
raw_matrix = zeros(n_sys, 5);

for k = 1:n_sys
    p = points.(fn{k});
    raw_matrix(k, :) = [p.t02, p.t05, p.t08, p.nu, p.zeta];
end


is_finite = all(isfinite(raw_matrix), 2);

t02_not_zero = (raw_matrix(:, 1) > 1e-9); % removes t02 = 0 bc of tau
%Mp_not_zero = (raw_matrix(:, 6) > 1e-9);


valid_rows = t02_not_zero & is_finite; %& Mp_not_zero;
filteredPoints = raw_matrix(valid_rows, :);

% gemini log code
fprintf('--- Limpeza de Dados (Matriz Final) ---\n');
fprintf('Sistemas totais: %d\n', n_sys);
fprintf('Removidos (NaN/Inf): %d\n', sum(~is_finite));
fprintf('Removidos (t02 = 0): %d\n', sum(is_finite & ~t02_not_zero));
fprintf('Sistemas prontos para fit: %d\n', size(filteredPoints, 1));



save(fullfile(outputFolder, 'filteredPoints.mat'), 'filteredPoints');
