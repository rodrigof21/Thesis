%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% Validation of the Peak (Mp and tp). Filters the database to loop ONLY 
% through systems where a peak was detected in extractPoints.m. Made with
% Gemini
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

validated_results = struct();
valid_count = 0;

hFig = figure('Name', 'Peak Validation Tool (Filter: Peaks Only)', 'Color', 'w', 'Position', [100, 100, 1000, 600]);

%% 2. Validation Loop: Only for systems WITH peaks
fprintf('--- Starting Peak Validation (Mp) ---\n');
fprintf('Filtering database for systems with valid peaks...\n');
fprintf('Press [Y] if Peak is correct | [N] to discard | [Esc] to finish and save\n\n');

for i = 1:num_entries
    sym_field = sprintf('sim_%d', i);
    sys_field = sprintf('sys_%d', i);
    
    if isfield(data_storage, sym_field) && isfield(points, sys_field)
        
        % Extração de dados para verificação de filtro
        tp_check = points.(sys_field).tp;
        
        % --- FILTRO CRÍTICO: Ignorar sistemas sem pico identificado ---
        % Se tp for NaN ou 0, o script salta para o próximo sem abrir o gráfico
        if isnan(tp_check) || tp_check <= 0
            continue; 
        end
        
        % Se passou o filtro, carregamos o resto dos dados para o plot
        t = data_storage.(sym_field).t;
        y = data_storage.(sym_field).y;
        Mp_rel = points.(sys_field).Mp;
        
        % Plot para Validação
        clf(hFig);
        plot(t, y, 'LineWidth', 1.5, 'Color', [0.15 0.35 0.55]); hold on; grid on;
        
        % Marcar o pico (Y absoluto = 1 + Mp_relativo)
        plot(tp_check, 1 + Mp_rel, 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y');
        yline(1, '--', 'Color', [0.5 0.5 0.5]);
        
        title(sprintf('System %d | \\nu=%.2f \\zeta=%.2f', i, data_storage.(sym_field).nu, data_storage.(sym_field).zeta));
        xlabel('Time (s)'); ylabel('Amplitude');
        legend('Step Response', 'Extracted Peak');
        
        % Interação com o utilizador
        isValidInput = false;
        while ~isValidInput
            waitforbuttonpress;
            key = get(hFig, 'CurrentKey');
            
            if strcmp(key, 'y')
                valid_count = valid_count + 1;
                f_name = sprintf('valid_%d', valid_count);
                
                % Guardar os dados validados
                validated_results.(f_name) = data_storage.(sym_field); 
                validated_results.(f_name).Mp_rel = Mp_rel;
                validated_results.(f_name).tp = tp_check;
                validated_results.(f_name).t05 = points.(sys_field).t05;
                validated_results.(f_name).t02 = points.(sys_field).t02;
                validated_results.(f_name).t08 = points.(sys_field).t08;
                
                fprintf('System %d (ID: %s) VALIDATED. Total: %d\n', i, sys_field, valid_count);
                isValidInput = true;
            elseif strcmp(key, 'n')
                isValidInput = true;
            elseif strcmp(key, 'escape')
                isValidInput = true;
            end
        end
        
        if strcmp(key, 'escape'), break; end
    end
end

%% 3. Save Final Results
if valid_count > 0
    fullPath = fullfile(outputFolder, 'double_validated_points.mat');
    save(fullPath, 'validated_results');
    fprintf('\nSuccess! %d systems with peaks were validated.\n', valid_count);
else
    fprintf('\nNo peaks were validated.\n');
end