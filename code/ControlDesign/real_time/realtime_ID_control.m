% =========================================================================
% BENCHMARK: ARX IDENTIFICATION + ZN (MATCHING THESIS GRID 8x10)
% =========================================================================

wn = 1;
ts = 0.5;
t = 0:ts:60;

% Grelha das imagens (8 linhas x 10 colunas = 80 modelos)
nu_vec   = 0.5:0.2:1.9;
zeta_vec = 0.5:0.5:5.0;
rng(42);

total = length(nu_vec) * length(zeta_vec);

% Matrizes de ITAE nas dimensoes exatas da tabela do Excel (8 x 10)
ITAE_SShape   = NaN(length(nu_vec), length(zeta_vec));
ITAE_CritGain = NaN(length(nu_vec), length(zeta_vec));

N_filter = 100;
t_eval = linspace(0, t(end), 2000);
count = 1;

for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        nu = nu_vec(i);
        zeta = zeta_vec(j);
        
        % 0. Estabilidade em Malha Aberta
        is_stable = checkStability(nu, zeta);
        if ~is_stable
            ITAE_SShape(i, j)   = Inf;
            ITAE_CritGain(i, j) = Inf;
            fprintf('Unstable: nu=%.1f, zeta=%.1f (%d/%d)\n', nu, zeta, count, total);
            count = count + 1;
            continue;
        end
        
        % Planta real fracionaria
        G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
        u = ones(length(t), 1);
        y_clean = step(G, t);
        
        % Ruido de medicao
        noise_level = 0.01;
        y = y_clean + noise_level * randn(size(y_clean));
        
        % -----------------------------------------------------------------
        % 1. IDENTIFICACAO ARX VIA RLS
        % -----------------------------------------------------------------
        theta = zeros(4, 1);
        r = eye(4) * 0.1;
        for k = 1:length(y)
            if k == 1
                uk_1 = 0; yk_1 = 0; yk_2 = 0;
            elseif k == 2
                uk_1 = u(1); yk_1 = y(1); yk_2 = 0;
            else
                uk_1 = u(k-1); yk_1 = y(k-1); yk_2 = y(k-2);
            end
            a_k = [u(k); uk_1; -yk_1; -yk_2];
            err = y(k) - theta' * a_k;
            [theta, r] = online_ID(theta, r, a_k, err);
        end
        
        % Modelo ARX final identificado
        b0 = theta(1); b1 = theta(2);
        a1 = theta(3); a2 = theta(4);
        G_arx_z = tf([b0, b1], [1, a1, a2], ts);
        G_arx_s = d2c(G_arx_z, 'tustin');
        
        % -----------------------------------------------------------------
        % 2. Z-N S-SHAPE (Apenas no dominio valido: nu <= 0.9)
        % -----------------------------------------------------------------
        if nu <= 0.9
            try
                t_fine = linspace(0, t(end), 2000);
                y_step_arx = step(G_arx_s, t_fine);
                
                if max(y_step_arx) > 1.001
                    ITAE_SShape(i, j) = NaN;
                else
                    dy = diff(y_step_arx) ./ diff(t_fine(:));
                    [max_slope, idx_inflex] = max(dy);
                    
                    t_inflex = t_fine(idx_inflex);
                    y_inflex = y_step_arx(idx_inflex);
                    K_stat = dcgain(G_arx_s);
                    if abs(K_stat) < 1e-3, K_stat = 1; end
                    
                    L = t_inflex - (y_inflex / max_slope);
                    t_end_slope = t_inflex + ((K_stat - y_inflex) / max_slope);
                    T_const = t_end_slope - L;
                    
                    if L <= 0, L = ts / 2; end
                    if T_const <= 0, T_const = t(end) / 4; end
                    
                    Kp = 1.2 * (T_const / (K_stat * L));
                    Ti = 2.0 * L;
                    Td = 0.5 * L;
                    Ki = Kp / Ti;
                    Kd = Kp * Td;
                    
                    % Malha fechada na planta fracionaria
                    C_pid = tf([Kd*N_filter + Kp, Kp*N_filter + Ki, Ki*N_filter], [1, N_filter, 0]);
                    T_closed = feedback(fotf(C_pid) * G, 1);
                    y_cl = step(T_closed, t_eval);
                    
                    if any(isnan(y_cl)) || any(isinf(y_cl)) || max(abs(y_cl)) > 50
                        ITAE_SShape(i, j) = Inf;
                    else
                        e_cl = 1 - y_cl;
                        ITAE_SShape(i, j) = trapz(t_eval, t_eval(:) .* abs(e_cl(:)));
                    end
                end
            catch
                ITAE_SShape(i, j) = NaN;
            end
        else
            ITAE_SShape(i, j) = NaN; % Fora do dominio valido (azul na imagem)
        end
        
        % -----------------------------------------------------------------
        % 3. Z-N CRITICAL GAIN (Apenas no dominio valido: nu >= 1.1)
        % -----------------------------------------------------------------
        if nu >= 1.1
            try
                % Usa a margem de G (ou filtra Gm falso de Tustin)
                [Gm_real, ~, ~, ~] = margin(G);
                [Gm, ~, Wcg, ~] = margin(G_arx_s);
                
                % Se a planta continua nao tinha Kcr, o do Tustin e artefato
                if Gm_real >= 1e4 || isnan(Gm) || isinf(Gm) || Gm >= 1e4 || Wcg <= 0
                    ITAE_CritGain(i, j) = NaN;
                else
                    Kcr = Gm;
                    Pcr = 2 * pi / Wcg;
                    
                    Kp = 0.6 * Kcr;
                    Ti = 0.5 * Pcr;
                    Td = 0.125 * Pcr;
                    Ki = Kp / Ti;
                    Kd = Kp * Td;
                    
                    C_pid = tf([Kd*N_filter + Kp, Kp*N_filter + Ki, Ki*N_filter], [1, N_filter, 0]);
                    T_closed = feedback(fotf(C_pid) * G, 1);
                    y_cl = step(T_closed, t_eval);
                    
                    if any(isnan(y_cl)) || any(isinf(y_cl)) || max(abs(y_cl)) > 50
                        ITAE_CritGain(i, j) = Inf;
                    else
                        e_cl = 1 - y_cl;
                        ITAE_CritGain(i, j) = trapz(t_eval, t_eval(:) .* abs(e_cl(:)));
                    end
                end
            catch
                ITAE_CritGain(i, j) = NaN;
            end
        else
            ITAE_CritGain(i, j) = NaN; % Fora do dominio valido (azul na imagem)
        end
        
        fprintf('Done: %d/%d (nu=%.1f, zeta=%.1f) | S-Shape: %.4f | CritGain: %.4f\n', ...
            count, total, nu, zeta, ITAE_SShape(i, j), ITAE_CritGain(i, j));
        count = count + 1;
    end
end


%% Estatísticas Globais: ARX + Z-N S-Shape e Critical Gain (Gama Global)
methods = {'Z-N S-Shape (Gama Global)', 'Z-N Critical Gain (Gama Global)'};
matrices = {ITAE_SShape, ITAE_CritGain};

% 1. Universo Global Elegível: todas as plantas que são estáveis em malha aberta
% Qualquer uma das matrizes serve para detetar os Inf de malha aberta instável
mask_open_loop_stable = ~isinf(ITAE_SShape(:));
total_elegiveis_global = sum(mask_open_loop_stable);

fprintf('\n====================================================================\n');
fprintf('    BENCHMARK METRICS: ARX + ZIEGLER-NICHOLS (GLOBAL RANGE, noise = 0.01)\n');
fprintf('====================================================================\n');
fprintf('Total de Plantas Estáveis na Grelha: %d\n\n', total_elegiveis_global);

for m = 1:2
    mat = matrices{m};
    vec = mat(:);
    
    % 2. Casos com Sucesso: têm de ser estáveis em malha aberta,
    % ter conseguido sintonizar (~isnan) e ter ITAE <= 200
    mask_sucesso = mask_open_loop_stable & ~isnan(vec) & (vec <= 200);
    valid_itae = vec(mask_sucesso);
    
    total_sucesso = sum(mask_sucesso);
    success_rate_global = (total_sucesso / total_elegiveis_global) * 100;
    
    if ~isempty(valid_itae)
        media_val   = mean(valid_itae);
        mediana_val = median(valid_itae);
        max_val     = max(valid_itae);
    else
        media_val   = NaN;
        mediana_val = NaN;
        max_val     = NaN;
    end
    
    fprintf('--- %s ---\n', methods{m});
    fprintf('  Total Elegíveis na Grelha : %d\n', total_elegiveis_global);
    fprintf('  Casos com Sucesso (<= 200): %d\n', total_sucesso);
    fprintf('  Success Rate Global (%%)   : %.2f %%\n', success_rate_global);
    fprintf('  Media ITAE (<= 200)       : %.4f\n', media_val);
    fprintf('  Mediana ITAE              : %.4f\n', mediana_val);
    fprintf('  Maximo ITAE (<= 200)      : %.4f\n\n', max_val);
end
fprintf('====================================================================\n');


function [theta, R] = online_ID(theta_old, R_old, a, err)
    alpha = 1;
    R = R_old + alpha * (a * a');
    theta = theta_old + alpha * (R \ a) * err;
end