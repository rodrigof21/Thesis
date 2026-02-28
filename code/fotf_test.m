%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCIRPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Testing step responses with fotf toolbox
%==========================================================================

nu = 0.3;
zeta = 2.0;
wn = 0.5;

G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
figure, step(G);
title('fotf')

u = @(s) 1./s;
Gs = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
[t, y] = invFourierTrapz(Gs, u, 100, 0.01);
figure, plot(t, y);
title('invFourier')