%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% This program uses the [[invFourierTest.m]] function to compute the unit
% step response of a system and compare it to the actual unit step response
% with step(G(s))
%
% INPUTS:
%   - G: system to analyse
%   - tfinal: time of analysis
%
% OUTPUTS:
%   - step response image
%
% OUTPUT FOLDER: N/A
%
% MODEL TYPE: N/A
%==========================================================================

% Assign current loop parameters
nu = 0.5;
zeta = 0.7;
wn = 100;

% System (99)
G = @(s) wn.^2 ./ (s.^(nu+1) + 2.*zeta.*wn.*s.^nu + wn.^2);

% System (4)
%G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

u = @(s) 1./s; % unit step
tfinal = 10;

%[tout, yout] = invFourierRiemann(G, tfinal, u);
[tout, yout] = invFourierTrapz(G, tfinal, u);

figure, plot(tout, yout)
axis([0 tfinal 0 1.2])

