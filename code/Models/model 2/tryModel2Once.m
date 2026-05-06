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

nu_real = 1.8;
zeta_real = 3;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 1;
u = @(s) 1./s;
G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));


[t02, t05, t08] = extractPoints(nu_real, zeta_real, wn);
fprintf('t02 = %.2f t05 = %.2f t08 = %.2f\n', t02, t05, t08)


% Id params
[nu_g0, zeta_g0, nu_g1, zeta_g1] = identify2(t02, t05, t08);


% % ID natural frequency
% % load Model
% load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\wnid_model.mat')
% 
% log_a0 = fitresult(nu_g0, zeta_g0);
% a0 = exp(log_a0);
% wn_g0 = a0/t05;
% 
% log_a1 = fitresult(nu_g1, zeta_g1);
% a1 = exp(log_a1);
% wn_g1 = a1/t05;

wn_g0 = wn;
wn_g1 = wn;

% Guessed Model
G_guess0 = @(s) 1 ./ (1 + 2.*zeta_g0.*(s/wn_g0).^nu_g0 + (s/wn_g0).^(nu_g0+1));
G_guess1 = @(s) 1 ./ (1 + 2.*zeta_g1.*(s/wn_g1).^nu_g1 + (s/wn_g1).^(nu_g1+1));


[t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
[t_guess0, y_guess0] = invFourierTrapz(G_guess0, u, 60, 0.05);
[t_guess1, y_guess1] = invFourierTrapz(G_guess1, u, 60, 0.05);

fprintf('Real: nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
fprintf('Guess0: nu = %.2f and zeta = %.2f\n', nu_g0, zeta_g0);
fprintf('Guess1: nu = %.2f and zeta = %.2f\n', nu_g1, zeta_g1);
fprintf('Real wn = %.2f\n', wn);
% fprintf('Guess wn0 = %.2f\n', wn_g0);
% fprintf('Guess wn1 = %.2f\n', wn_g1);

figure
plot(t_real, y_real, 'DisplayName', 'Real'), hold on
plot(t_guess0, y_guess0, 'DisplayName', 'Guess0')
plot(t_guess1, y_guess1, 'DisplayName', 'Guess1')
legend('show');

% err0 = y_real-y_guess0;
% err1 = y_real-y_guess1;
% rms0 = sqrt(mean(err0.^2));
% rms1 = sqrt(mean(err1.^2));
% fprintf('RMS0 = %.3f\n', rms0);
% fprintf('RMS1 = %.3f\n', rms1);

