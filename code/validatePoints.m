%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION:
% Used to validate the extracted points in [[extractPoints.m]]
%
% OUTPUT FOLDER: results\validatedPoints
%==========================================================================

clear; clc; close all;

outputFolder = 'results/validatedPoints';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

%% 1. Load your databases
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat')
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\extractPoints\Points.mat')

all_fields = fieldnames(points);
num_entries = length(all_fields);
validated_results = struct(); 
valid_count = 0;

fprintf('--- Manual Validation Started ---\n');
fprintf('Instructions: CLICK THE FIGURE once to start.\n');
fprintf('Press [Y] to Accept | Press [N] to Discard | Press [Esc] to Exit\n\n');

hFig = figure('Name', 'Overshoot Validation Tool', 'Color', 'w', 'Position', [100, 100, 1000, 600]);

%% 2. Processing Loop
for i = 1:num_entries
    sym_field = sprintf('sim_%d', i); % Using 'sim_' as per your script
    sys_field = sprintf('sys_%d', i);
    
    if isfield(data_storage, sym_field) && isfield(points, sys_field)
        
        % Extract Data
        t = data_storage.(sym_field).t;
        y = data_storage.(sym_field).y;
        nu_val = data_storage.(sym_field).nu;
        zeta_val = data_storage.(sym_field).zeta;
        
        % Extract Points
        Mp_relative = points.(sys_field).Mp;
        tp = points.(sys_field).tp;
        t05 = points.(sys_field).t05;
        
        % CALCULATE OFFSET: Mp is relative to y_final
        y_final = y(end);
        Mp_absolute = y_final + Mp_relative;
        
        % --- Plotting ---
        clf(hFig);
        plot(t, y, 'LineWidth', 1.5, 'Color', [0.15 0.35 0.55]);
        hold on; grid on;
        
        % Plot the absolute peak point
        plot(tp, Mp_absolute, 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y');
        
        % Visual Reference for Steady State
        yline(y_final, '--', 'Color', [0.5 0.5 0.5], 'HandleVisibility', 'off');
        
        % Formatting
        title_str = sprintf('System [%d/%d]: %s | \\nu = %.2f, \\zeta = %.2f', i, num_entries, sys_field, nu_val, zeta_val);
        title(title_str, 'FontSize', 12);
        xlabel('Time (t)'); ylabel('Response (y)');
        legend('Step Response', ['Peak: ', num2str(Mp_absolute, '%.3f')], 'Location', 'best');
        
        % Visual guides for the peak
        xline(tp, '--r', 'HandleVisibility', 'off', 'Alpha', 0.4);
        yline(Mp_absolute, '--r', 'HandleVisibility', 'off', 'Alpha', 0.4);
        
        % --- Keyboard Interaction ---
        isValidInput = false;
        while ~isValidInput
            waitforbuttonpress;
            key = get(hFig, 'CurrentKey');
            
            if strcmp(key, 'y')
                valid_count = valid_count + 1;
                valid_field = sprintf('valid_%d', valid_count);
                
                validated_results.(valid_field).nu = nu_val;
                validated_results.(valid_field).zeta = zeta_val;
                validated_results.(valid_field).Mp_rel = Mp_relative;
                validated_results.(valid_field).Mp_abs = Mp_absolute;
                validated_results.(valid_field).tp = tp;
                validated_results.(valid_field).t05 = t05;
                validated_results.(valid_field).y_final = y_final;
                validated_results.(valid_field).t = t;
                validated_results.(valid_field).y = y;
                
                fprintf('System %d: [ACCEPTED] (Mp_abs: %.3f)\n', i, Mp_absolute);
                isValidInput = true;
                
            elseif strcmp(key, 'n')
                fprintf('System %d: [DISCARDED]\n', i);
                isValidInput = true;
                
            elseif strcmp(key, 'escape')
                fprintf('Exiting and saving progress...\n');
                isValidInput = true;
            end
        end
        if strcmp(key, 'escape'), break; end
    end
end

%% 3. Save
if valid_count > 0
    fullPath = fullfile(outputFolder, 'validated_points_database.mat');
    save(fullPath, 'validated_results');
    fprintf('\nSuccess! %d systems validated and saved.\n', valid_count);
else
    fprintf('\nNo data was saved.\n');
end