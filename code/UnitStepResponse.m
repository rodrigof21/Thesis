%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
%
% PROGRAM DESCRIPTION: 
%
%
% INPUTS:
%
%
% OUTPUTS:
%
%
% OUTPUT FOLDER:
%
% MODEL STRUCTURE: G(s) = wn^2 / (s^(nu+1) + 2*zeta*wn*s^nu + wn^2)
%==========================================================================


G = @(s) 1./(s+1);
u = @(s) 1./s; % unit step
tfinal = 50;

[tout, yout] = invFourierTest(G, tfinal, u);

figure, plot(tout, yout)

% compare with real step response
hold on
s = tf('s');
Gs = 1/(s+1);
step(Gs, 50);

