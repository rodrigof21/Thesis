% S-Shape ZN

nu_values = 0.5:0.2:1.9;
zeta_values = 0.5:0.5:5;

nu_values = 1.5;
zeta_values = 0.5;

ITAE = zeros(length(nu_values), length(zeta_values));
total = length(nu_values)*length(zeta_values);
count = 1;

open PID_arch.slx

for i = 1:length(nu_values)
    for j = 1:length(zeta_values)

        % Params
        nu = nu_values(i);
        zeta = zeta_values(j);
        wn = 1;
        
        is_stable = checkStability(nu, zeta);
        if ~is_stable
            fprintf('unstable\n')
            ITAE(i, j) = Inf;
            fprintf('%.i/%.i\n', count, total)
            count = count+1;
            continue
        end
        
        G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
        
        % print and paste simulink block
        coef_1 = 1 / (wn^(nu+1));
        ord_1 = nu + 1;
        coef_2 = (2*zeta) / (wn^nu);
        ord_2 = nu;
        str_polos = sprintf('%g*s^%g + %g*s^%g + 1', coef_1, ord_1, coef_2, ord_2);
        set_param('PID_arch/Controlled FTF','polePoly', str_polos);
        set_param('PID_arch/Free FTF','polePoly', str_polos);        
        
        % Step response data
        t = 0:0.01:60;
        y = step(G, t);
        K = y(end);

        if max(y) > 1.001
            fprintf('Not S-Shaped\n')
            ITAE(i, j) = NaN;
            fprintf('%.i/%.i\n', count, total)
            count = count+1;
            continue
        end
        
        % inflexion point
        dy = gradient(y, t);
        [max_slope, idx] = max(dy, [], 'all');
        t_inf = t(idx);
        y_inf = y(idx);
        
        % Z-N params
        T = K / max_slope;
        theta = t_inf - (y_inf / max_slope);
        
        if theta <= 1e-3
            fprintf('no inflection point\n')
            ITAE(i, j) = NaN;
            fprintf('%.i/%.i\n', count, total)
            count = count+1;
            continue
        end
        
        % Controller Setup

        % % P
        % Kp = T/(theta*K);
        
        % % PI
        % Kp = (0.9*T)/(theta*K);
        % Ti = theta/0.3;
        % Ki = Kp/Ti;
        
        % PID
        Kp = (1.2*T)/(theta*K);
        Ti = 2*theta;
        Td = 0.5*theta;
        Ki = Kp/Ti;
        Kd = Kp*Td;
                
        % running the simulation
        data = sim("PID_arch.slx");
        
        %plot the simulations
        
        t_ctrl = data.controlled.Time;
        y_ctrl = data.controlled.Data;        
        
               
        % Error metric - ITAE
        
        r = ones(size(y_ctrl));
        err = r - y_ctrl;
        
        ITAE(i, j) = trapz(t_ctrl, t_ctrl .*abs(err));
        fprintf('ITAE = %.4f\n', ITAE(i, j));
        fprintf('%.i/%.i\n', count, total)
        count = count+1;

    end
end


figure,
plot(t, y, 'DisplayName', 'System'), hold on
plot(t_ctrl, y_ctrl, 'DisplayName', 'PID Controlled')
grid on
legend('show')


















%% PLot from gemini with ZN params

% figure;
% plot(t, y, 'b', 'LineWidth', 2); hold on;
% 
% % tangent line
% t_tangent = linspace(max(0, theta-1), t_inf + T + 1, 100);
% y_tangent = max_slope * (t_tangent - theta);
% 
% % points and plot
% plot(t_tangent, y_tangent, 'r--', 'LineWidth', 1.5);
% yline(K, 'k:', 'LineWidth', 1);
% xline(theta, 'g:', 'LineWidth', 1.5);
% plot(t_inf, y_inf, 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 8); % inflexion point
% 
% % graph configs
% ylim([0 K*1.2]);
% xlim([0 max(t_tangent)]);
% title('Ziegler-Nichols params');
% xlabel('Time (s)');
% ylabel('Amplitude');
% legend('Step Response', 'Tangent', 'K = 1', '\theta', 'Inf. Point', 'Location', 'Southeast');
% grid on;

