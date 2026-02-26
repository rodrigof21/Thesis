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

nu = 1;
zeta = 0;
wn = 1;


G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
step(G)