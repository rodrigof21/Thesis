%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% This program aims to check if varying wn is a scale factor in time. Uses 
% [[inFourierTrapz]] or step().
%
% INPUTS:
%   - None
%
% OUTPUTS:
%   - Image comparing step responses of various systems with different wn.
%
% OUTPUT FOLDER: results/varyingWn
%
% MODEL TYPE: N/A
%==========================================================================

%% Is it a sacle factor in time?

w = [0.5 0.7 1 1.5 2 5];
%w = 1;
max_y = zeros(length(w), 1);
tmax = zeros(length(w), 1);
figure,
for i = 1:length(w)

    % parameters
    nu = 1.4;
    zeta = 0.2;
    stable = checkStability(nu, zeta);
    if stable, fprintf('Stable\n')
    else, fprintf('Unstable\n'), close all, return
    end
    wn = w(i);

    % System (99)
    %G = @(s) wn.^2 ./ (s.^(nu+1) + 2.*zeta.*wn.*s.^nu + wn.^2);

    % System (4)    
    G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

    u = @(s) 1./s; % unit step
    tfinal = 25;

    [tout, yout] = invFourierTrapz(G, u, tfinal, 0.05);

    plot(tout, yout);
    hold on
    
    % % Evalute overshoot time
    % [max_y(i), idx_max] = max(yout);
    % tmax(i) = tout(idx_max);

    % evaluate t05
    idx05 = find(yout >= 0.5, 1);
    tmax(i) = tout(idx05);
    max_y(i) = yout(idx05);

    plot(tmax(i), max_y(i), 'ro')
end

hold off

% settings and saving -------------------------
%legend(sprintf('wn = %.1f', w(1)), sprintf('wn = %.1f', w(2)), sprintf('wn = %.1f', w(3)), sprintf('wn = %.1f', w(4)));
title('step response comparison (4)')
xlabel('time')
ylabel('amplitude')
% % save img
% fileName = 'varyingWncomparison99.png';
% outputFolder = 'results/varyingWn';
% if ~exist(outputFolder, 'dir')
%     mkdir(outputFolder);
% end
% saveas(gcf, fullfile(outputFolder, fileName));
% close(gcf); 

