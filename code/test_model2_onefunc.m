% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% testing the function [[identify2.m]] but with only one value for each
% parameter
%
% OUTPUT FOLDER: N/A
%==========================================================================

nu_real = 0.24;
zeta_real = 1.83;

stable = checkStability(nu_real, zeta_real);
if stable, fprintf('Stable\n')
else, fprintf('Unstable\n'), return
end


[t02, t05, t08] = extractPoints(nu_real, zeta_real);
[nu_g, zeta_g] = identify2(t02, t05, t08);

G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn).^nu_g + (s/wn).^(nu_g+1));

[t_real, y_real] = invFourierTrapz(G_real, u, 120, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 120, 0.05);

figure
plot(t_real, y_real, 'DisplayName', 'real'), hold on
plot(t_guess, y_guess, 'DisplayName', 'guess');
legend('show')

% Display values
fprintf('real: nu = %.2f, zeta=%.2f\n', nu_real, zeta_real)
fprintf('guess: nu = %.2f, zeta=%.2f\n', nu_g, zeta_g)

% RMS
err = y_real - y_guess;
rms_test = sqrt(mean(err.^2));
fprintf('RMS = %.6f\n', rms_test);