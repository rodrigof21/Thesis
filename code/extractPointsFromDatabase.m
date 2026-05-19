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

    points.(fieldname).t02 = extractTime(data.t, data.y, 0.2);
    points.(fieldname).t05 = extractTime(data.t, data.y, 0.5);
    points.(fieldname).t07 = extractTime(data.t, data.y, 0.7);
    points.(fieldname).t08 = extractTime(data.t, data.y, 0.8);
    points.(fieldname).t01 = extractTime(data.t, data.y, 0.1);
    points.(fieldname).t09 = extractTime(data.t, data.y, 0.9);
    points.(fieldname).t95 = extractTime(data.t, data.y, 0.95);
    points.(fieldname).t99 = extractTime(data.t, data.y, 0.99);

    %other data
    points.(fieldname).nu = data.nu;
    points.(fieldname).zeta = data.zeta;

    
    % Console Log
    %fprintf('Status: %d/%d\n', count, total);
    count = count+1;
end

fprintf('Complete\n');
save(fullfile(outputFolder, 'Points.mat'), 'points')


function t_level = extractTime(t, y, level)
    % Remove pontos não finitos
    valid = isfinite(y) & isfinite(t);
    t = t(valid);
    y = y(valid);
    
    if isempty(t)
        t_level = NaN;
        return;
    end
    
    idx = find(y >= level, 1);
    
    if isempty(idx) || idx <= 1
        t_level = NaN;
        return;
    end
    
    % Usa janela de 4 pontos para pchip (mais estável)
    i0 = max(1, idx-2);
    i1 = min(length(y), idx+1);
    
    try
        t_level = interp1(y(i0:i1), t(i0:i1), level, 'pchip');
    catch
        % fallback linear
        t_level = interp1(y(idx-1:idx), t(idx-1:idx), level, 'linear');
    end
end