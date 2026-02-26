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
    [max_y, idx_p] = max(data.y);
    points.(fieldname).Mp = max_y - 1; %data.y(end);
    points.(fieldname).tp = data.t(idx_p);

    % t_0.5
    idx_50 = find(data.y >= 0.5, 1);
    if isempty(idx_50)
        t05 = NaN; 
    else
        t05 = data.t(idx_50); 
    end
    points.(fieldname).t05 = t05;

    %other data
    points.(fieldname).nu = data.nu;
    points.(fieldname).zeta = data.zeta;
    
    % Console Log
    %fprintf('Status: %d/%d\n', count, total);
    count = count+1;
end

fprintf('Complete\n');
save(fullfile(outputFolder, 'Points.mat'), 'points')
