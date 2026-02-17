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
% OUTPUT FOLDER: results/unitStepResponses_img
%
% MODEL TYPE: G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
%==========================================================================


outputFolder = 'results/unitStepResponses_img';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

nu_v = 0.0:0.1:1.2;
zeta_v = 0.0:0.1:1.2;
wn = 1;

u = @(s) 1./s;

count = 1;
total = length(nu_v)*length(zeta_v);

for i = 1:length(nu_v)
    for j = 1:length(zeta_v)
        
        nu = nu_v(i);
        zeta = zeta_v(j);

        G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
        
        tfinal = 30;
        ts = 0.05;

        [t, y] = invFourierTrapz(G, u, tfinal, ts);
        
        h = figure('Visible','off');
        plot(t, y);

        title_str = sprintf('Step Response: \\nu=%.1f, \\zeta=%.1f, \\omega_n=%d', nu, zeta, wn);
        title(title_str);

        fileName = sprintf('stepResponse_nu%.1f_zeta%.1f.png', nu, zeta);
        saveas(h, fullfile(outputFolder, fileName));
        close(h);

        fprintf('Status: %d/%d | Saved: %s\n', count, total, fileName);
        count = count + 1;
    end
end
