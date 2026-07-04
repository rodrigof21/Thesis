clear; clc;
% 1. Carregar os modelos guardados
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models.mat")


nu_vec = 0.6:0.1:1.9;
zeta_vec = 0.2:0.1:5;
ITAE_matrix = zeros(length(nu_vec), length(zeta_vec));
gains = zeros(length(nu_vec), length(zeta_vec), 4);

wn = 1;
t_sim = 0:0.1:30;

for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        n_t = nu_vec(i);
        z_t = zeta_vec(j);

        is_stable = checkStability(n_t, z_t);
        if ~is_stable
            ITAE_matrix(i, j) = Inf;
            gains(i, j, 1) = Inf;
            gains(i, j, 2) = Inf;
            gains(i, j, 3) = Inf;
            gains(i, j, 4) = Inf;
            continue
        end
        % 
        % Extrair ganhos da struct PID_Models
        Kp = exp(PID_Models.fit_Kp(n_t, z_t));
        Ki = exp(PID_Models.fit_Ki(n_t, z_t));
        Kd = exp(PID_Models.fit_Kd(n_t, z_t));
        Tf = 20;

        G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);
        C = fotf([1/Tf, 1], [2, 1], [(Kp/Tf + Kd), (Kp + Ki/Tf), Ki], [2, 1, 0]);

        [Gm, Pm, Wcg, Wcp] = margin(C * G);
        Tf_new = 3*Wcp;
        C = fotf([1/Tf_new, 1], [2, 1], [(Kp/Tf_new + Kd), (Kp + Ki/Tf_new), Ki], [2, 1, 0]);

        T = feedback(C*G, 1);
        [y, t] = step(T, t_sim);

        % % Extrair ganhos da struct PID_Models
        % Kp = exp(PID_Models.fit_Kp(n_t, z_t));
        % Ki = exp(PID_Models.fit_Ki(n_t, z_t));
        % Kd = exp(PID_Models.fit_Kd(n_t, z_t));
        % 
        % % 1. A Sonda (PID Ideal para descobrir o Wcp real imposto pelos ganhos)
        % % C_ideal(s) = Kd*s^2 + Kp*s + Ki / s
        % C_ideal = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]); 
        % 
        % % Obter as margens da malha compensada ideal (Wcp é a tua omega_c)
        % G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);
        % [Gm, Pm, Wcg, Wcp] = margin(C_ideal * G);
        % 
        % % 2. O Controlador Real (com o filtro adaptativo a 3x a bandwidth)
        % Tf_new = 3 * Wcp;
        % C_real = fotf([1/Tf_new, 1], [2, 1], [(Kp/Tf_new + Kd), (Kp + Ki/Tf_new), Ki], [2, 1, 0]);
        % 
        % % 3. Simulação
        % T = feedback(C_real * G, 1);
        % [y, t] = step(T, t_sim);
        
        ITAE_matrix(i,j) = trapz(t(:), t(:) .* abs(1 - y(:)));
        gains(i, j, 1) = Kp;
        gains(i, j, 2) = Ki;
        gains(i, j, 3) = Kd;
        gains(i, j, 4) = Tf_new;
    end
end

% figure; mesh(zeta_vec, nu_vec, ITAE_matrix);
% xlabel('\zeta'); ylabel('\nu'); zlabel('ITAE');
% title('Mapa Global de Performance ITAE (Modelos Analíticos)');