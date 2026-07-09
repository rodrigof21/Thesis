clear; clc;

load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models.mat")

nu_vec = 0.6:0.1:1.9;
zeta_vec = 0.2:0.1:5;
wn = 1;

ITAE_matrix = zeros(length(nu_vec), length(zeta_vec));
gains = zeros(length(nu_vec), length(zeta_vec), 4);

t_sim = 0:0.1:30;
r = ones(size(t_sim)); % step input
rng(42); 


for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)
        n_t = nu_vec(i);
        z_t = zeta_vec(j);
        
        if ~checkStability(n_t, z_t)
            ITAE_matrix(i, j) = Inf;
            gains(i, j, :) = Inf;
            continue
        end
        
        n_sensor = 0.02 * randn(size(t_sim));

        % Plant
        G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);
        
        % gains
        Kp = exp(PID_Models.fit_Kp(n_t, z_t));
        Ki = exp(PID_Models.fit_Ki(n_t, z_t));
        Kd = exp(PID_Models.fit_Kd(n_t, z_t));
        
        % without Tf
        C = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]);

        [~, ~, ~, Wcp] = margin(C*G);
        Tf = 1/(3*Wcp);        

        % with Tf

        Cp = fotf(1, 0, Kp, 0);
        Ci = fotf(1, 1, Ki, 0);
        Cd = fotf([Tf, 1], [1, 0], Kd, 1);
        C = Cp + Ci + Cd;
        
        T_ry = feedback(C * G, 1);
        y_ref= lsim(T_ry, r, t_sim);
        
        % if any(isnan(y_ref)) || any(isinf(y_ref)) || max(abs(y_ref)) > 1e3
        %     ITAE_matrix(i, j) = Inf;
        %     gains(i, j, :) = Inf;
        %     continue;
        % end
        
        % simulates the noise part
        y_noise = lsim(-T_ry, n_sensor, t_sim);
        y_total = y_ref + y_noise;
        
        % ITAE with noise
        err_noisy = 1 - y_total;
        ITAE_matrix(i, j) = trapz(t_sim(:), t_sim(:) .* abs(err_noisy(:)));
        
        % save
        gains(i, j, 1) = Kp;
        gains(i, j, 2) = Ki;
        gains(i, j, 3) = Kd;
        gains(i, j, 4) = Tf;
    end
end

itae_validos = ITAE_matrix(~isinf(ITAE_matrix));
fprintf('Max ITAE (w/ noise): %.4f\n', max(itae_validos));
fprintf('Min ITAE (w/ noise): %.4f\n', min(itae_validos));

% % graph
% figure;
% mesh(zeta_vec, nu_vec, ITAE_matrix);
% xlabel('\zeta'); ylabel('\nu'); zlabel('ITAE');
% title('ITAE performance');
% grid on;


%% test one case

t_sim = 0:0.1:30;
r = ones(size(t_sim)); % step input
rng(42);
n_sensor = 0.02 * randn(size(t_sim));

nu_choice   = 1.1;
zeta_choice = 1.6;

n_t = nu_choice;
z_t = zeta_choice;

if ~checkStability(n_t, z_t)
    error('O ponto escolhido (nu=%.2f, zeta=%.2f) é instável — escolha outro.', n_t, z_t);
end

% Plant
G = fotf([1/(wn^(n_t+1)), (2*z_t)/(wn^n_t), 1], [n_t+1, n_t, 0], 1, 0);

% gains
Kp = exp(PID_Models.fit_Kp(n_t, z_t));
Ki = exp(PID_Models.fit_Ki(n_t, z_t));
Kd = exp(PID_Models.fit_Kd(n_t, z_t));

% Tf
C_noTf = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]);
[Gm, Pm, Wcg, Wcp] = margin(C_noTf*G);
Tf = 1/(3*Wcp);

% controller
Cp = fotf(1, 0, Kp, 0);
Ci = fotf(1, 1, Ki, 0);
Cd = fotf([Tf, 1], [1, 0], Kd, 1);
C_real = Cp + Ci + Cd;

% closed loop
T_ry = feedback(C_real * G, 1);
S    = feedback(1, C_real * G);
CS   = C_real * S;

y_ref   = lsim(T_ry, r, t_sim);
y_noise = lsim(-T_ry, n_sensor, t_sim);
y_controlled = y_ref + y_noise;


y_uncontrolled = lsim(G, r, t_sim);
y_uncontrolled = y_uncontrolled + n_sensor';


u_ref   = lsim(CS, r, t_sim);
u_noise = lsim(-CS, n_sensor, t_sim);
u_total = u_ref + u_noise;

% --- Plot ---
figure('Name', sprintf('\\nu=%.2f, \\zeta=%.2f, Tf=%.4f', n_t, z_t, Tf));

% subplot(2,1,1);
plot(t_sim, r, 'k--', 'LineWidth', 1); hold on;
plot(t_sim, y_uncontrolled, 'g', 'LineWidth', 1.2);
plot(t_sim, y_controlled, 'b', 'LineWidth', 1.2);
xlabel('t [s]'); ylabel('y(t)');
legend('ref', 'open loop', 'closed loop', 'Location', 'best');
title(sprintf('open vs closed loop — \\nu=%.2f, \\zeta=%.2f, T_f=%.4f s', n_t, z_t, Tf));
grid on;

% subplot(2,1,2);
% plot(t_sim, u_total, 'r', 'LineWidth', 1.2);
% xlabel('t [s]'); ylabel('u(t)');
% title('Sinal de controlo (esforço do controlador)');
% grid on;