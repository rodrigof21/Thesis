nu_real = 0.8;
zeta_real = 3;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 1;
u = @(s) 1./s;
G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));


[tau1, tau2, tau3, tau4, tau5, tp, Mp] = extractPoints_final(nu_real, zeta_real, wn);


load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final.mat")

% ID Logic

if Mp >= 10e-5
    model = idModel_final.peak;
    zeta_g = model(log(tau1), tau2);
else
    model = idModel_final.npeak;
    zeta_g = model(log(tau3), tau4);
end

if zeta_g >= 2
    model2 = idModel_final.nu_1;
    nu_g = model2(tau5, tau3);
else
    model2 = idModel_final.nu_2;
    nu_g = model2(tau5, zeta_g);
end



% % ID natural frequency
% % load Model
% load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\wnid_model.mat')
% 
% log_a = fit_wn(nu_g, zeta_g);
% a = exp(log_a);
% wn_g = a/t05;

wn_g = wn;


% Guessed Model
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn_g).^nu_g + (s/wn_g).^(nu_g+1));


[t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);

fprintf('Real: nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
fprintf('Guess: nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);
fprintf('Real wn = %.2f\n', wn);
fprintf('Guess wn = %.2f\n', wn_g);

figure
plot(t_real, y_real, 'DisplayName', 'Real'), hold on
plot(t_guess, y_guess, 'DisplayName', 'Guess')
legend('show');

err = y_real-y_guess;
rms = sqrt(mean(err.^2));
fprintf('RMS = %.3f\n', rms);




%% Functions

function [tau1, tau2, tau3, tau4, tau5, tp, Mp] = extractPoints_final(nu_test, zeta_test, wn_test)

    G_test = @(s) 1 ./ (1 + 2.*zeta_test.*(s/wn_test).^nu_test + (s/wn_test).^(nu_test+1));
    u = @(s) 1./s;
    [data.t, data.y] = invFourierTrapz(G_test, u, 60, 0.05);
    
    % Mp tp Overshoot
    [pks, locs] = findpeaks(data.y, data.t, 'MinPeakHeight', 1.0001);
    if ~isempty(pks) && pks(1) - 1 > 0.05
        Mp = pks(1) - 1; 
        tp = locs(1);
    else
        Mp = 0;
        tp = 0; % Ou o tempo final da simulação
    end

    % t_0.5
    idx_50 = find(data.y >= 0.5, 1);
    if isempty(idx_50)
        t05 = NaN; 
    else
        t05 = data.t(idx_50); 
    end


    % t_0.2
    idx_20 = find(data.y >= 0.2, 1);
    if isempty(idx_20)
        t02 = NaN; 
    else
        t02 = data.t(idx_20); 
    end


    % t_0.8
    idx_80 = find(data.y >= 0.8, 1);
    if isempty(idx_80)
        t08 = NaN; 
    else
        t08 = data.t(idx_80); 
    end


    % t_0.7
    idx_70 = find(data.y >= 0.7, 1);
    if isempty(idx_70)
        t07 = NaN; 
    else
        t07 = data.t(idx_70); 
    end


    % t_0.1
    idx_10 = find(data.y >= 0.1, 1);
    if isempty(idx_10)
        t01 = NaN; 
    else
        t01 = data.t(idx_10); 
    end


    % t_0.9
    idx_90 = find(data.y >= 0.9, 1);
    if isempty(idx_90)
        t09 = NaN; 
    else
        t09 = data.t(idx_90); 
    end



    tau1 = (t07/tp);
    tau2 = (t08-t05)/(t05-t02);
    tau3 = (t01/t05);
    tau4 = t08/t02;
    tau5 = t05/t09;

end