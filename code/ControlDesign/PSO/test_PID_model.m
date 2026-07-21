clear; clc;
% 1. Carregar os modelos guardados
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models.mat")


% nu_vec = 0.7:0.1:1.9;
% zeta_vec = 0.2:0.1:5;
nu_vec = 1.5;
zeta_vec = 2.1;

ITAE_matrix = zeros(length(nu_vec), length(zeta_vec));
gains = zeros(length(nu_vec), length(zeta_vec), 4);
max_os = zeros(length(nu_vec), length(zeta_vec));
set_time = zeros(length(nu_vec), length(zeta_vec));


wn = 1;
t_sim = 0:0.1:30;

count = 1;
total = length(nu_vec)*length(zeta_vec);


for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        n_t = nu_vec(i);
        z_t = zeta_vec(j);

        is_stable = checkStability(n_t, z_t);
        if ~is_stable
            ITAE_matrix(i, j) = Inf;
            gains(i, j, :) = Inf;
            fprintf('%.i / %.i\n', count, total);
            count = count+1;
            max_os(i, j) = Inf;
            set_time(i, j) = Inf;
            continue
        end
        
        G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);


        % Extrair ganhos da struct PID_Models
        Kp = exp(PID_Models.fit_Kp(n_t, z_t));
        Ki = exp(PID_Models.fit_Ki(n_t, z_t));
        Kd = exp(PID_Models.fit_Kd(n_t, z_t));

        % without Tf
       
        C = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]);

        [Gm, Pm, Wcg, Wcp] = margin(C*G);
        Tf = 1/(3*Wcp);        
        
        % with Tf
                
        Cp = fotf(1, 0, Kp, 0);
        Ci = fotf(1, 1, Ki, 0);
        Cd = fotf([Tf, 1], [1, 0], Kd, 1);
        C = Cp + Ci + Cd;


        T = feedback(C*G, 1);
        [y, t] = step(T, t_sim);
        
        ITAE_matrix(i,j) = trapz(t(:), t(:) .* abs(1 - y(:)));
        gains(i, j, 1) = Kp;
        gains(i, j, 2) = Ki;
        gains(i, j, 3) = Kd;
        gains(i, j, 4) = Tf;

        max_os(i, j) = max(y);

        % settling time 5%
        banda = 0.05;
        dentro_da_banda = abs(y - 1) <= banda;
        idx_fora = find(~dentro_da_banda, 1, 'last');
        if isempty(idx_fora)
            ts = t(1);
        elseif idx_fora == length(t)
            ts = NaN;
        else
            ts = t(idx_fora + 1);
        end
        
        set_time(i, j) = ts;

        fprintf('%.i / %.i\n', count, total);
        count = count+1;
    end
end

% figure; mesh(zeta_vec, nu_vec, ITAE_matrix);
% xlabel('\zeta'); ylabel('\nu'); zlabel('ITAE');
% title('Mapa Global de Performance ITAE (Modelos Analíticos)');

itae = ITAE_matrix(:);
itae = itae(~isinf(itae));
fprintf('máximo ITAE: %.4f\n', max(itae))

figure, 
plot(t, y, 'DisplayName', 'Closed Coop')
hold on
step(G, t_sim);
grid on
legend('Closed Loop', 'Open Loop');

open max_os
open set_time