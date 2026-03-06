%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Tests the identification method in the previous files.
%
%==========================================================================

nu_init = 1.7;
zeta_init = 3.27;
wn = 1;
u = @(s) 1./s;
tfinal = 60;
ts = 0.05;

[t02, t05, t08, Mp, tp] = extractPoints(nu_init, zeta_init);
fprintf(sprintf('Defined Parameters: nu=%.2f zeta=%.2f\n', nu_init, zeta_init))
[nu_final, zeta_final] = identify_system(t02, t05, t08);



G_real = @(s) 1 ./ (1 + 2.*zeta_init.*(s/wn).^nu_init + (s/wn).^(nu_init+1));
G_test = @(s) 1 ./ (1 + 2.*zeta_final.*(s/wn).^nu_final + (s/wn).^(nu_final+1));

[t_real, y_real] = invFourierTrapz(G_real, u, tfinal, ts);
[t_test, y_test] = invFourierTrapz(G_test, u, tfinal, ts);

figure, plot(t_real, y_real), hold on
plot(t_test, y_test)

legend('real', 'test');


err = y_real - y_test;
rms = sqrt(mean(err.^2));
fprintf('RMS = %.2f\n', rms);