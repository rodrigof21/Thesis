%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% The goal is to test the invFourier functions with known systems and the
% respective step responses and compares it with the actual step response
%
% INPUTS:
%   - NONE
%
% OUTPUTS:
%   - image comparing the two step responses
%
% OUTPUT FOLDER: N/A
%
% MODEL TYPE: N/A
%==========================================================================


% Unit Step
u = @(s) 1./s;

% First Order System
%G = @(s) 1./(s + 1);

%Second order system
G = @(s) 25./(s.^2 + 2*0.7.*s + 25);

tfinal = 20;
[t, y] = invFourierTrapz(G, u, tfinal, 0.05);

figure, plot(t, y);
hold on

% Comparison with real step response

s = tf('s');
%Gs = 1/(s+1);
Gs = 25/(s^2 + 2*0.7*s + 25);
step(Gs, tfinal, 'r')

legend('test', 'real')
axis([0 tfinal 0 max(y)+0.1])
title('Unit Step Response of G(s)')
xlabel('t(s)')
ylabel('Amplitude')

