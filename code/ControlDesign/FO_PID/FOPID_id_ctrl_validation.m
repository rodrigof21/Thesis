% Load models
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final.mat")
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\FO_PID\results\FOPID_Models.mat")

% nu_vec = 0.7:0.1:1.9;
% zeta_vec = 0.2:0.1:5;

nu_vec = 0.7;
zeta_vec = 3.4;


ITAE_matrix = zeros(length(nu_vec), length(zeta_vec));
gains = zeros(length(nu_vec), length(zeta_vec), 6);
nu_guess = zeros(length(nu_vec), length(zeta_vec));
zeta_guess = zeros(length(nu_vec), length(zeta_vec));

wn = 1;
t_sim = 0:0.05:30;

total = length(nu_vec)*length(zeta_vec);
count = 1;

for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        nu_real = nu_vec(i);
        zeta_real = zeta_vec(j);

        is_stable = checkStability(nu_real, zeta_real);
        if ~is_stable
            ITAE_matrix(i, j) = Inf;
            gains(i, j, :) = Inf;
            fprintf('Unstable\n');
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end
   
        % Real Curve
        u = @(s) 1./s;
        G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
        [t_real, y_clean] = invFourierTrapz(G_real, u, t_sim(end), 0.05);
        
        % the same but in fotf
        G = fotf([1/(wn^(nu_real+1)), (2*zeta_real)/(wn^nu_real), 1], [nu_real+1, nu_real, 0], 1, 0);
        
        % Add noise
        rng(42); % seed
        noise_level = 0.01;
        noise = noise_level * randn(size(y_clean));
        y_noise = y_clean + noise;

        % % Filter Data 
        % y_filtered1 = lowpass(y_noise, 0.1);
        y_filtered = movmean(y_noise, 11);
        % y_filtered = sgolayfilt(y_noise, 3, 15);
        % y_filtered = filtfilt(b, a, y_noise);

        % Point Extraction from noisy curve
        [tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_noise(t_real, y_filtered);


        % Fallback
        if isnan(tau1) || isnan(tau2) || isnan(tau3) || isnan(tau4) || isnan(tau5) || isnan(t05)
            ITAE_matrix(i, j) = Inf;
            fprintf('non existing time\n')
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end
        

        if Mp >= 0.05
            model = idModel_final.peak;
            z_t = model(log(tau1), tau2);
        else
            model = idModel_final.npeak;
            z_t = model(log(tau3), tau4);
        end
        
        if z_t >= 2
            model2 = idModel_final.nu_1;
            n_t = model2(tau5, tau3);
        else
            model2 = idModel_final.nu_2;
            n_t = model2(tau5, z_t);
        end

        nu_guess(i, j) = n_t;
        zeta_guess(i, j) = z_t;

        %Estimated system (w/ est params)
        G_est = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);

        Kp     = FOPID_Models.fit_Kp(n_t, z_t);
        Ki     = exp(FOPID_Models.fit_Ki(n_t, z_t));
        Kd     = FOPID_Models.fit_Kd(n_t, z_t);
        lambda = FOPID_Models.fit_lam(n_t, z_t);
        mu     = FOPID_Models.fit_mu(n_t, z_t);

        % before tf
        Cp = fotf(1, 0, Kp, 0);
        Ci = fotf(1, lambda, Ki, 0);
        Cd_ideal = fotf(1, 0, Kd, mu);
        C_ideal = Cp + Ci + Cd_ideal;

        [Gm, Pm, Wcg, Wcp] = margin(C_ideal * G_est);
        Tf = 1 / (3 * Wcp);  
        
        % with Tf
                
        Cd_real = fotf([Tf, 1], [mu, 0], Kd, mu);
        C_real  = Cp + Ci + Cd_real;


        T = feedback(C_real*G, 1);
        [y, t] = step(T, t_sim);
        
        itae_now = trapz(t(:), t(:) .* abs(1 - y(:)));
        ITAE_matrix(i,j) = itae_now;
        gains(i, j, 1) = Kp;
        gains(i, j, 2) = Ki;
        gains(i, j, 3) = Kd;
        gains(i, j, 4) = Tf;
        gains(i, j, 5) = lambda;
        gains(i, j, 6) = mu;
    
        fprintf('%.i/%.i\n', count, total);
        %fprintf('ITAE = %.4f\n',  itae_now)
        count=count+1;
    end
end

% figure; mesh(zeta_vec, nu_vec, ITAE_matrix);
% xlabel('\zeta'); ylabel('\nu'); zlabel('ITAE');
% title('Mapa Global de Performance ITAE (Modelos Analíticos)');

itae = ITAE_matrix(:);
itae = itae(~isinf(itae));
fprintf('máximo ITAE: %.4f\n', max(itae))
fprintf('real: nu = %.2f | zeta = %.2f\n', nu_real, zeta_real)
fprintf('guess: nu = %.2f | zeta = %.2f\n', n_t, z_t)


% % Plot one curve
% figure, 
% plot(t_real, y_clean, 'DisplayName', ' Real Curve'), hold on
% plot(t, y, 'DisplayName', 'Closed Loop')
% grid on
% legend('show')

open ITAE_matrix






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
    
    t_level = t(idx);

    % % Keep this if without noise
    % i0 = max(1, idx-2);
    % i1 = min(length(y), idx+1);
    % 
    % try
    %     t_level = interp1(y(i0:i1), t(i0:i1), level, 'pchip');
    % catch
    %     % fallback linear
    %     t_level = interp1(y(idx-1:idx), t(idx-1:idx), level, 'linear');
    % end
end


function [tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_noise(t, y)
    
    
    % % Mp tp Overshoot with findpeaks()  --> may not work with noise, use
    % without noise
    % [pks, locs] = findpeaks(y(1:600), t(1:600), 'MinPeakHeight', 1.05);
    % if ~isempty(pks) && pks(1) - 1 > 0.05
    %     Mp = pks(1) - 1; 
    %     tp = locs(1);
    % else
    %     Mp = 0;
    %     tp = 0; % Ou o tempo final da simulação
    % end

    % Mp tp Overshoot with max()
    [max_val, idx_max] = max(y(1:400));

    Mp_candidato = max_val - 1;

    if Mp_candidato > 0.05
        Mp = Mp_candidato;
        tp = t(idx_max);
    else
        Mp = 0;
        tp = 0;
    end


    t01 = extractTime(t, y, 0.1);
    t02 = extractTime(t, y, 0.2);
    t05 = extractTime(t, y, 0.5);
    t07 = extractTime(t, y, 0.7);
    t08 = extractTime(t, y, 0.8);
    t09 = extractTime(t, y, 0.9);


    tau1 = (t07/tp);
    tau2 = (t08-t05)/(t05-t02);
    tau3 = (t01/t05);
    tau4 = t08/t02;
    tau5 = t05/t09;

end