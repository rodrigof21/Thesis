nu_real = 1.3;
zeta_real = 1.8;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

wn = 1;
u = @(s) 1./s;
G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));


[tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_final(nu_real, zeta_real, wn);


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



% ID natural frequency
% load Model
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\effectsOfWn_coefficients\wnid_model.mat')

log_a = fit_wn(nu_g, zeta_g);
a = exp(log_a);
wn_g = a/t05;



% Guessed Model
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn_g).^nu_g + (s/wn_g).^(nu_g+1));


[t_real, y_real] = invFourierTrapz(G_real, u, 20, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 20, 0.05);

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


% fprintf('--- VALORES EXTRAÍDOS NO TESTE REAL ---\n');
% fprintf('Mp calculado: %.6f\n', Mp);
% fprintf('tau1 (t07/tp): %.4f\n', tau1);
% fprintf('tau2 ((t08-t05)/(t05-t02)): %.4f\n', tau2);
% fprintf('tau3 (t01/t05): %.4f\n', tau3);
% fprintf('tau4 (t08/t02): %.4f\n', tau4);
% fprintf('tau5 (t05/t09): %.4f\n', tau5);






%% Functions

function [tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_final(nu_test, zeta_test, wn_test)

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


    t01 = extractTime(data.t, data.y, 0.1);
    t02 = extractTime(data.t, data.y, 0.2);
    t05 = extractTime(data.t, data.y, 0.5);
    t07 = extractTime(data.t, data.y, 0.7);
    t08 = extractTime(data.t, data.y, 0.8);
    t09 = extractTime(data.t, data.y, 0.9);


    tau1 = (t07/tp);
    tau2 = (t08-t05)/(t05-t02);
    tau3 = (t01/t05);
    tau4 = t08/t02;
    tau5 = t05/t09;

end


function t_level = extractTime(t, y, level)
    % Remove pontos não finitos
    valid = isfinite(y) & isfinite(t);
    t = t(valid);
    y = y(valid);
    
    if isempty(t)
        t_level = NaN;
        return;
    end
    
    idx = find(y >= level, 1);
    
    if isempty(idx) || idx <= 1
        t_level = NaN;
        return;
    end
    
    % Usa janela de 4 pontos para pchip (mais estável)
    i0 = max(1, idx-2);
    i1 = min(length(y), idx+1);
    
    try
        t_level = interp1(y(i0:i1), t(i0:i1), level, 'pchip');
    catch
        % fallback linear
        t_level = interp1(y(idx-1:idx), t(idx-1:idx), level, 'linear');
    end
end