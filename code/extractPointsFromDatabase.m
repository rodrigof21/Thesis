%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% This program loops through the database in order to extract the interest
% points of every system.
%
% OUTPUT FOLDER: results\extractPoints
%==========================================================================

outputFolder = 'results/extractPoints';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat');

sys = fieldnames(data_storage);
total = length(sys);
count = 1;

points = struct();

for k = 1:length(sys)
    
    current = sys{k};
    data = data_storage.(current);

    fieldname = sprintf('sys_%d', count);

    % Mp tp Overshoot
    [pks, locs] = findpeaks(data.y, data.t, 'MinPeakHeight', 1.05);
    if ~isempty(pks)
        points.(fieldname).Mp = pks(1) - 1; 
        points.(fieldname).tp = locs(1);
    else
        points.(fieldname).Mp = 0;
        points.(fieldname).tp = NaN; % Ou o tempo final da simulação
    end

    % t_0.5
    idx_50 = find(data.y >= 0.5, 1);
    if isempty(idx_50)
        t05 = NaN; 
    else
        t05 = data.t(idx_50); 
    end
    points.(fieldname).t05 = t05;

    % t_0.2
    idx_20 = find(data.y >= 0.2, 1);
    if isempty(idx_50)
        t02 = NaN; 
    else
        t02 = data.t(idx_20); 
    end
    points.(fieldname).t02 = t02;

    % t_0.8
    idx_80 = find(data.y >= 0.8, 1);
    if isempty(idx_50)
        t08 = NaN; 
    else
        t08 = data.t(idx_80); 
    end
    points.(fieldname).t08 = t08;

    %other data
    points.(fieldname).nu = data.nu;
    points.(fieldname).zeta = data.zeta;
    
    % Console Log
    %fprintf('Status: %d/%d\n', count, total);
    count = count+1;
end

fprintf('Complete\n');
save(fullfile(outputFolder, 'Points.mat'), 'points')
