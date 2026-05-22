nu_real = 0.7;
zeta_real = 1;
wn = 1;

stable = checkStability(nu_real, zeta_real);
if ~stable, fprintf('Unstable\n'), return
end

% Real Curve
u = @(s) 1./s;
G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
[t_real, y_clean] = invFourierTrapz(G_real, u, 60, 0.05);

% % Adds noise
% rng(42);
% noise_level = 0.0;
% noise = noise_level * randn(size(y_clean));
% y_noise = y_clean + noise;
% 
% % Filter Data
% %y_filtered = movmean(y_noise, 10);
% % y_filtered = lowpass(y_noise, 0.05);
% y_filtered = y_noise;

% Point Extraction from noisy curve
[tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_noise(t_real, y_clean);


% ID Logic
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final.mat")

if Mp >= 0.05
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
% wn_g = a/t05;
wn_g = wn;



% Guessed Model
G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn_g).^nu_g + (s/wn_g).^(nu_g+1));


%[t_real, y_real] = invFourierTrapz(G_real, u, 20, 0.05);
[t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);

fprintf('Real: nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
fprintf('Guess: nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);
fprintf('Real wn = %.2f\n', wn);
fprintf('Guess wn = %.2f\n', wn_g);

figure
%plot(t_real, y_filtered, 'DisplayName', 'Noisy'), hold on
plot(t_guess, y_guess, 'DisplayName', 'Guess'), hold on
plot(t_guess, y_clean, 'DisplayName', 'Real')
legend('show');

err = y_clean-y_guess;
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


function [tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_noise(t, noise_y)
    
    
    % Mp tp Overshoot
    [pks, locs] = findpeaks(noise_y, t, 'MinPeakHeight', 1.05);
    if ~isempty(pks) && pks(1) - 1 > 0.05
        Mp = pks(1) - 1; 
        tp = locs(1);
    else
        Mp = 0;
        tp = 0; % Ou o tempo final da simulação
    end

    % % --- Abordagem usando o Máximo Absoluto (Substitui o findpeaks) ---
    % [max_val, idx_max] = max(noise_y(1:600));
    % 
    % % O overshoot (Mp) é a amplitude máxima menos o valor de regime estacionário (1)
    % Mp_candidato = max_val - 1;
    % 
    % % Só consideramos overshoot verdadeiro se passar o teu limiar de 0.05 (5%)
    % if Mp_candidato > 0.05
    %     Mp = Mp_candidato;
    %     tp = t(idx_max); % O tempo do pico é o tempo associado ao índice do máximo
    % else
    %     Mp = 0;
    %     tp = 0;
    % end


    t01 = extractTime(t, noise_y, 0.1);
    t02 = extractTime(t, noise_y, 0.2);
    t05 = extractTime(t, noise_y, 0.5);
    t07 = extractTime(t, noise_y, 0.7);
    t08 = extractTime(t, noise_y, 0.8);
    t09 = extractTime(t, noise_y, 0.9);


    tau1 = (t07/tp);
    tau2 = (t08-t05)/(t05-t02);
    tau3 = (t01/t05);
    tau4 = t08/t02;
    tau5 = t05/t09;

end