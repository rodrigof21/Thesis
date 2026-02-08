%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: FUNCTION
% First test of a function that implements a inverse Fourier transformation
% with the Riemann integral sum - based on [[Inverse Fourier]]
%
% INPUTS:
%   - G: System G = @(s) ...
%   - u: input u= @(s) ...
%   - tf: final time
%
% OUTPUTS:
%   - t: time for the response
%   - y: response in time domain
%
% OUTPUT FOLDER: N/A
%
%==========================================================================

function [t, y] = invFourierTest(G, tf, u)

    % frequency params
    dw = 0.0001;
    wmax = 500;
    w = dw:dw:wmax;
    
    t = 0:0.05:tf;
    y = zeros(size(t));
    
    Gjw = G(1j*w);
    ujw = u(1j*w);
    
    % riemann loop
    for i = 1:length(t)
        integrand = (Gjw .* ujw) .* exp(1j*w*t(i));
    
        y(i) = (1/pi) * real(sum(integrand) * dw) + 0.5 * real(G(0));
    end

end



