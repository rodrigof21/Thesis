%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Two-stage validation: First validate Overshoot (Mp), then validate Rise Time (t0.5)
%
% OUTPUT FOLDER: results\validatedPoints
%==========================================================================

clear; clc; close all;
outputFolder = 'results/validatedPoints';
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end

%% 1. Load your databases
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat')
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\extractPoints\Points.mat')

all_fields = fieldnames(points);
num_entries = length(all_fields);

% Intermediate storage for Mp-validated systems
temp_results = struct(); 
mp_valid_count = 0;

hFig = figure('Name', 'Sequential Validation Tool', 'Color', 'w', 'Position', [100, 100, 1000, 600]);

%% 2. STAGE 1: Validate Overshoot (Mp)
fprintf('--- STAGE 1: Validating Overshoot (Mp) ---\n');
fprintf('Press [Y] if Mp is correct | [N] to discard system | [Esc] to skip to Stage 2\n\n');

for i = 1:num_entries
    sym_field = sprintf('sim_%d', i);
    sys_field = sprintf('sys_%d', i);
    
    if isfield(data_storage, sym_field) && isfield(points, sys_field)
        t = data_storage.(sym_field).t;
        y = data_storage.(sym_field).y;
        y_final = y(end);
        Mp_abs = y_final + points.(sys_field).Mp;
        tp = points.(sys_field).tp;

        % Plot for Mp validation
        clf(hFig);
        plot(t, y, 'LineWidth', 1.5, 'Color', [0.15 0.35 0.55]); hold on; grid on;
        plot(tp, Mp_abs, 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y');
        yline(y_final, '--', 'Color', [0.5 0.5 0.5]);
        title(sprintf('STAGE 1 (Mp): System %d | \\nu=%.2f \\zeta=%.2f', i, data_storage.(sym_field).nu, data_storage.(sym_field).zeta));
        legend('Step Response', 'Identified Peak (Mp)');

        % Key Handling
        isValidInput = false;
        while ~isValidInput
            waitforbuttonpress;
            key = get(hFig, 'CurrentKey');
            if strcmp(key, 'y')
                mp_valid_count = mp_valid_count + 1;
                f_name = sprintf('valid_%d', mp_valid_count);
                temp_results.(f_name) = data_storage.(sym_field); % Save original data
                temp_results.(f_name).Mp_rel = points.(sys_field).Mp;
                temp_results.(f_name).tp = tp;
                temp_results.(f_name).t05 = points.(sys_field).t05;
                isValidInput = true;
            elseif strcmp(key, 'n') || strcmp(key, 'escape'), isValidInput = true; end
        end
        if strcmp(key, 'escape'), break; end
    end
end

%% 3. STAGE 2: Validate Rise Time (t0.5) from Mp-Validated Results
if mp_valid_count == 0, error('No systems passed Mp validation.'); end

validated_results = struct();
final_valid_count = 0;
temp_fields = fieldnames(temp_results);

fprintf('--- STAGE 2: Validating Rise Time (t05) ---\n');
fprintf('Press [Y] if t05 is correct | [N] to discard system | [Esc] to finish\n\n');

for j = 1:length(temp_fields)
    data = temp_results.(temp_fields{j});
    
    % Rise time point is usually at 50% of steady state
    y_target = data.y(end) * 0.5; 
    
    % Plot for t05 validation
    clf(hFig);
    plot(data.t, data.y, 'LineWidth', 1.5, 'Color', [0.15 0.35 0.55]); hold on; grid on;
    % Mark Mp (already validated)
    plot(data.tp, data.y(end)+data.Mp_rel, 'ko', 'MarkerSize', 6); 
    % Mark t05 (to be validated) - marked with a blue X
    plot(data.t05, y_target, 'bx', 'MarkerSize', 12, 'LineWidth', 2);
    
    title(sprintf('STAGE 2 (t0.5): System %d | Target y=%.3f', j, y_target));
    legend('Step Response', 'Validated Mp', 'Extracted t_{0.5}');

    isValidInput = false;
    while ~isValidInput
        waitforbuttonpress;
        key = get(hFig, 'CurrentKey');
        if strcmp(key, 'y')
            final_valid_count = final_valid_count + 1;
            f_name = sprintf('final_%d', final_valid_count);
            validated_results.(f_name) = data;
            isValidInput = true;
        elseif strcmp(key, 'n') || strcmp(key, 'escape'), isValidInput = true; end
    end
    if strcmp(key, 'escape'), break; end
end

%% 4. Save Final Results
if final_valid_count > 0
    fullPath = fullfile(outputFolder, 'double_validated_points.mat');
    save(fullPath, 'validated_results');
    fprintf('\nSuccess! %d systems passed both validations.\n', final_valid_count);
else
    fprintf('\nNo data was saved.\n');
end