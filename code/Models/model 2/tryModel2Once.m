%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% tests specific values for nu and zeta for Model 2
%
% OUTPUT FOLDER: N/A
%==========================================================================

nu_real = 0.03;
zeta_real = 0.43;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 1;
u = @(s) 1./s;

[t02, t05, t08] = extractPoints(nu_real, zeta_real);

fprintf('t02 = %.2f t05 = %.2f t08 = %.2f\n', t02, t05, t08)

[nu_g, zeta_g] = identify2(t02, t05, t08);

G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn).^nu_g + (s/wn).^(nu_g+1));


[t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);

fprintf('nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);

figure
plot(t_real, y_real, 'DisplayName', 'Real'), hold on
plot(t_guess, y_guess, 'DisplayName', 'Guess')
legend('show');

err = y_real-y_guess;
rms = sqrt(mean(err.^2));
fprintf('RMS = %.3f\n', rms);