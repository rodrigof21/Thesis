%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: FUNCTION
% First test of a function that implements a inverse Fourier transformation
% with the Trapz integral
%
% INPUTS:
%   - G: System G = @(s)
%   - u: input u= @(s)
%   - tf: final time
%   - ts: sampling time
%
% OUTPUTS:
%   - t: time for the response
%   - y: response in time domain
%
% OUTPUT FOLDER: N/A
%
% MODEL TYPE: N/A
%==========================================================================

% logspace omega

function [t, y] = invFourierTrapz(G, u, tfinal, ts)

    % frequency params
    %dw = 1e-3;
    %wmax = 1e3; %(10*pi)/ts;
    %wmin = dw; % CHECK THE VALUE FOR WMIN
    %w = wmin:dw:wmax;
    
    w = logspace(-4, 4, 8001); % 100 pts por decada

    t = 0:ts:tfinal;
    y = zeros(size(t));
    
    Gjw = G(1j*w);
    ujw = u(1j*w);
    
    % trapz
    for i = 1:length(t)
        integrand = (Gjw .* ujw) .* exp(1j*w*t(i));
    
        y(i) = (1/pi) * real(trapz(w, integrand)) + 0.5 * real(G(0));
    end
end

