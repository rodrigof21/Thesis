% Common parameters
wn = 1;
tfinal = 60;
ts = 0.01;
t = 0:ts:tfinal;
u  = @(s) 1./s;

% --- FIGURE 1: WITH OVERSHOOT ---
nu_atual   = 1.4; 
zeta_atual = 1.4; % Low damping yields overshoot

G_com = @(s) 1 ./ (1 + 2.*zeta_atual.*(s/wn).^nu_atual + (s/wn).^(nu_atual+1));
[t_com, y_com] = invFourierTrapz(G_com, u, tfinal, ts);

figure('Color', 'w', 'Position', [100, 100, 600, 400]);
plot(t_com, y_com, 'b', 'LineWidth', 1);
title('With Overshoot', 'FontSize', 11);
xlabel('Time (s)', 'FontSize', 10);
ylabel('Amplitude', 'FontSize', 10);
grid on;

% --- FIGURE 2: WITHOUT OVERSHOOT ---
nu_atual   = 0.9; 
zeta_atual = 1.5; % High damping eliminates overshoot

G_sem = @(s) 1 ./ (1 + 2.*zeta_atual.*(s/wn).^nu_atual + (s/wn).^(nu_atual+1));
[t_sem, y_sem] = invFourierTrapz(G_sem, u, tfinal, ts);

figure('Color', 'w', 'Position', [750, 100, 600, 400]);
plot(t_sem, y_sem, 'b', 'LineWidth', 1);
title('Without Overshoot', 'FontSize', 11);
xlabel('Time (s)', 'FontSize', 10);
ylabel('Amplitude', 'FontSize', 10);
grid on;
xlim([0 60]);
ylim([0 1.1]);