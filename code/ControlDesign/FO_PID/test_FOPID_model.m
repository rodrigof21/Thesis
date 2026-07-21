clear; clc;
% 1. Carregar os modelos guardados
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\FO_PID\results\FOPID_Models.mat")


nu_vec = 0.7:0.1:1.9;
zeta_vec = 0.2:0.1:5;

% nu_vec = 1.6;
% zeta_vec = 0.9;

ITAE_matrix = zeros(length(nu_vec), length(zeta_vec));
gains = zeros(length(nu_vec), length(zeta_vec), 6);

wn = 1;
t_sim = 0:0.05:30;

total = length(nu_vec)*length(zeta_vec);
count = 1;

for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        n_t = nu_vec(i);
        z_t = zeta_vec(j);

        is_stable = checkStability(n_t, z_t);
        if ~is_stable
            ITAE_matrix(i, j) = Inf;
            gains(i, j, :) = Inf;
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end
        
        G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);


        % gains from models
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

        [Gm, Pm, Wcg, Wcp] = margin(C_ideal * G);
        Tf = 1 / (3 * Wcp);
        
        % with Tf
                
        Cd_real = fotf([Tf, 1], [mu, 0], Kd, mu);
        C_real  = Cp + Ci + Cd_real;


        T = feedback(C_real*G, 1);
        [y, t] = step(T, t_sim);
        
        ITAE_matrix(i,j) = trapz(t(:), t(:) .* abs(1 - y(:)));
        gains(i, j, 1) = Kp;
        gains(i, j, 2) = Ki;
        gains(i, j, 3) = Kd;
        gains(i, j, 4) = Tf;
        gains(i, j, 5) = lambda;
        gains(i, j, 6) = mu;
        
        fprintf('%.i/%.i\n', count, total);
        count=count+1;

    end
end

% figure; mesh(zeta_vec, nu_vec, ITAE_matrix);
% xlabel('\zeta'); ylabel('\nu'); zlabel('ITAE');
% title('Global Performance ITAE');

itae = ITAE_matrix(:);
itae = itae(~isinf(itae));
fprintf('máximo ITAE: %.4f', max(itae))

figure, 
step(G, t_sim), hold on
plot(t, y)

