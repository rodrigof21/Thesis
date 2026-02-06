%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
%
% PROGRAM DESCRIPTION: 
% This Program plot the Bode diagram of various 
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

% 4. Triple Loop for automated generation
for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        for k = 1:length(wn_vec)
            
            % Assign current loop parameters
            nu = nu_vec(i);
            zeta = zeta_vec(j);
            wn = wn_vec(k);
            
            % --- System Construction ---
            % We define the G(s) = num / den
            % Denominator coefficients: [1, 2*zeta*wn, wn^2]
            % Denominator orders: [nu+1, nu, 0]
            
            a = [1, 2*zeta*wn, wn^2];
            na = [nu+1, nu, 0];
            b = [wn^2];
            nb = [0];
            
            % Create the fractional transfer function object
            G = fotf(a, na, b, nb);
            
            % 5. Plotting
            h = figure('Visible', 'off'); % Hidden window for batch processing
            bode(G);
            grid on;
            
            % Dynamic title based on current parameters
            title_str = sprintf('Bode Plot: \\nu=%.1f, \\zeta=%.1f, \\omega_n=%d', nu, zeta, wn);
            title(title_str);
            
            % 6. Exporting Results
            fileName = sprintf('Bode_nu%.1f_zeta%.1f_wn%d.png', nu, zeta, wn);
            saveas(h, fullfile(outputFolder, fileName));
            close(h); 
            
            % Console feedback
            fprintf('Status: %d/%d | Saved: %s\n', count, totalIterations, fileName);
            count = count + 1;
        end
    end
end

disp('====================================================');
disp('Execution Finished: Check the folder for output images.');
disp('====================================================');