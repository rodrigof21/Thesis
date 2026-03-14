%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: GAVE UP
%
% PROGRAM DESCRIPTION: 
% Tests Identification Model1
%
% OUTPUT FOLDER: N\A
%==========================================================================

nu_real = 1.7;
zeta_real = 3.27;
wn = 1;
u = @(s) 1./s;
tfinal = 60;
ts = 0.05;

[t02, t05, t08, Mp, tp] = extractPoints(nu_init, zeta_init);
fprintf(sprintf('Defined Parameters: nu=%.2f zeta=%.2f\n', nu_init, zeta_init))
[t, y] = 