%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% This program aims to check if varying wn is a scale factor in time. Uses 
% [[inFourierTest]] or step().
%
% INPUTS:
%   - None
%
% OUTPUTS:
%   - Image comparing step responses of various systems with different wn.
%
% OUTPUT FOLDER: results/varyingWn
%
%==========================================================================


w = [1 10 100 1000];

for i = 1:length(w)

    % parameters
    nu = 0.5;
    zeta = 1;
    wn = w(i);

    %G = @(s) wn.^2 ./ (s.^(nu+1) + 2.*zeta.*wn.*s.^nu + wn.^2);
    G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
    u = @(s) 1./s; % unit step
    tfinal = 100;

    [tout, yout] = invFourierTest(G, tfinal, u);

    plot(tout, yout);
    hold on
end


% settings and saving -------------------------
legend('wn = 1', 'wn = 10', 'wn = 100', 'wn = 1000');
title('step response comparison')
xlabel('time')
ylabel('amplitude')
% save img
fileName = 'varyingWncomparison2.png';
outputFolder = 'results/varyingWn';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
%saveas(gcf, fullfile(outputFolder, fileName));
%close(gcf); 