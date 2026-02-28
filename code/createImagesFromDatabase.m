%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% This program uses the databse in [[Database Values] to plot the unit step
% response of the various systems.
%
% INPUTS:
%   - N/A
%
% OUTPUTS:
%   - step response images
%
% OUTPUT FOLDER: results/unitStepResponses_img_test (currently)
%==========================================================================


outputFolder = 'results/unitStepResponses_img';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

%loads the database
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat')

sims = fieldnames(data_storage);

wn = 1;
count = 1;
total = length(sims);


for k = 1:length(sims)
    
    current_sim = sims{k};
    data = data_storage.(current_sim);

    h = figure('Visible','off');
    plot(data.t, data.y);

    title_str = sprintf('Step Response: \\nu=%.1f, \\zeta=%.1f, \\omega_n=%d', data.nu, data.zeta, wn);
    title(title_str);
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Fixed y-axis
    ylim([0 1.6]);

    fileName = sprintf('stepResponse_nu%.1f_zeta%.1f.png', data.nu, data.zeta);
    saveas(h, fullfile(outputFolder, fileName));
    close(h);

    fprintf('Status: %d/%d | Saved: %s\n', count, total, fileName);
    count = count + 1;
end

