%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Tests one model with noise
%
% OUTPUT FOLDER: N/A
%==========================================================================

nu_real = 1.6;
zeta_real = 0.8;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 1;
u = @(s) 1./s;

G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
[t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05); 

std = 0.05; % 0.01 0.02 0.05 0.1
noise = std * randn(size(y_real));
y_noise = y_real + noise;

[t02, t05, t08] = extractPoints2(t_real, y_noise);

[nu_g, zeta_g] = identify2(t02, t05, t08);
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn).^nu_g + (s/wn).^(nu_g+1));
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);
fprintf('Real: nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
fprintf('Guess: nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);

figure
plot(t_real, y_noise, 'DisplayName', 'Real'), hold on
plot(t_guess, y_guess, 'DisplayName', 'Guess')
legend('show');

err = y_real-y_guess;
rms = sqrt(mean(err.^2));
fprintf('RMS = %.3f\n', rms);