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

nu_real = 0.01;
zeta_real = 0.01;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 4;
u = @(s) 1./s;
G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));


[t02, t05, t08] = extractPoints(nu_real, zeta_real, wn);
fprintf('t02 = %.2f t05 = %.2f t08 = %.2f\n', t02, t05, t08)

tau = t08./t02;
tau2 = t05./t02;


% Id params
[nu_g, zeta_g] = identify2(t02, t05, t08);


% % ID natural frequency
% % load Model
% load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\wnid_model.mat')
% exp
% log_a0 = fitresult(nu_g0, zeta_g0);
% a0 = exp(log_a0);
% wn_g0 = a0/t05;
% 
% log_a1 = fitresult(nu_g1, zeta_g1);
% a1 = exp(log_a1);
% wn_g1 = a1/t05;

wn_g = wn;

% Guessed Model
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn_g).^nu_g + (s/wn_g).^(nu_g+1));


[t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);

fprintf('Real: nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
fprintf('Guess: nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);
% fprintf('Real wn = %.2f\n', wn);
% fprintf('Guess wn0 = %.2f\n', wn_g0);
% fprintf('Guess wn1 = %.2f\n', wn_g1);

figure
plot(t_real, y_real, 'DisplayName', 'Real'), hold on
plot(t_guess, y_guess, 'DisplayName', 'Guess')
legend('show');

err = y_real-y_guess;
rms = sqrt(mean(err.^2));
fprintf('RMS = %.3f\n', rms);


