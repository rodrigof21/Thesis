%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
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

    fieldname = current;

    % Mp tp Overshoot
    [pks, locs] = findpeaks(data.y, data.t, 'MinPeakHeight', 1.05);
    if ~isempty(pks) & pks(1) - 1 > 0.05
        points.(fieldname).Mp = pks(1) - 1; 
        points.(fieldname).tp = locs(1);
    else
        points.(fieldname).Mp = 0;
        points.(fieldname).tp = 0; % Ou o tempo final da simulação
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
    if isempty(idx_20)
        t02 = NaN; 
    else
        t02 = data.t(idx_20); 
    end
    points.(fieldname).t02 = t02;

    % t_0.8
    idx_80 = find(data.y >= 0.8, 1);
    if isempty(idx_80)
        t08 = NaN; 
    else
        t08 = data.t(idx_80); 
    end
    points.(fieldname).t08 = t08;

    % t_0.7
    idx_70 = find(data.y >= 0.7, 1);
    if isempty(idx_70)
        t07 = NaN; 
    else
        t07 = data.t(idx_70); 
    end
    points.(fieldname).t07 = t07;

    % t_0.1
    idx_10 = find(data.y >= 0.1, 1);
    if isempty(idx_10)
        t01 = NaN; 
    else
        t01 = data.t(idx_10); 
    end
    points.(fieldname).t01 = t01;

    % t_0.9
    idx_90 = find(data.y >= 0.9, 1);
    if isempty(idx_90)
        t09 = NaN; 
    else
        t09 = data.t(idx_90); 
    end

    % t_0.95
    idx_95 = find(data.y >= 0.95, 1);
    if isempty(idx_95)
        t95 = NaN; 
    else
        t95 = data.t(idx_95); 
    end

    % t_0.99
    idx_99 = find(data.y >= 0.99, 1);
    if isempty(idx_99)
        t99 = NaN; 
    else
        t99 = data.t(idx_99); 
    end

    points.(fieldname).t09 = t09;
    points.(fieldname).t95 = t95;
    points.(fieldname).t99 = t99;

    %other data
    points.(fieldname).nu = data.nu;
    points.(fieldname).zeta = data.zeta;

    
    % Console Log
    %fprintf('Status: %d/%d\n', count, total);
    count = count+1;
end

fprintf('Complete\n');
save(fullfile(outputFolder, 'Points.mat'), 'points')