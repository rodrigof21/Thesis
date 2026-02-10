%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% This Program plots the Bode diagram of various transfer functions with
% different values for nu, zeta and wn.
%
% INPUTS:
%   - nu_vec:   Vector of base fractional orders (e.g., [0.2, 0.5, 0.8]).
%   - zeta_vec: Vector of damping ratios (e.g., [0.3, 0.7, 1.2]).
%   - wn_vec:   Vector of natural frequencies in rad/s (e.g., [1, 5, 10]).
%
% OUTPUTS:
%   - Graphical: Bode plots for each parameter combination.
%   - Files:     PNG images saved to the 'Bode_Plots_Thesis' directory.
%
% OUTPUT FOLDER: /results/bode
%
% MODEL STRUCTURE: G(s) = wn^2 / (s^(nu+1) + 2*zeta*wn*s^nu + wn^2)
%==========================================================================


% 1. Parameter definition
nu_vec   = [0.2, 0.5, 0.8];
zeta_vec = [0.3, 0.7, 1.2];
wn_vec   = [1, 5, 10];

% 2. Directory setup
outputFolder = 'results/bode';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 3. Simulation Constants
count = 1;
totalIterations = length(nu_vec) * length(zeta_vec) * length(wn_vec);


for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        for k = 1:length(wn_vec)
            
            % Assign current loop parameters
            nu = nu_vec(i);
            zeta = zeta_vec(j);
            wn = wn_vec(k);
            
            % Denominator
            a = [1, 2*zeta*wn, wn^2];
            na = [nu+1, nu, 0]; % 1 / ( (s/w0)^(nu+1) + 2*zeta*(s/w0) + 1 )
            % Numerator
            b = wn^2;
            nb = 0;
            
            % transfer function object (den, num)
            G = fotf(a, na, b, nb);
            
            % plot
            h = figure('Visible', 'off'); % Hidden window
            bode(G);
            grid on;
            
            % title
            title_str = sprintf('Bode Plot: \\nu=%.1f, \\zeta=%.1f, \\omega_n=%d', nu, zeta, wn);
            title(title_str);
            
            % save img
            fileName = sprintf('Bode_nu%.1f_zeta%.1f_wn%d.png', nu, zeta, wn);
            saveas(h, fullfile(outputFolder, fileName));
            close(h); 
            
            % Console feedback
            fprintf('Status: %d/%d | Saved: %s\n', count, totalIterations, fileName);
            count = count + 1;
        end
    end
end



