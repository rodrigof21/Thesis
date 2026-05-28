% Critical Gain ZN

% nu_values = 0.5:0.2:1.9;
% zeta_values = 0.5:0.5:5;

nu_values = 1.5;
zeta_values = 0.5;

ITAE = zeros(length(nu_values), length(zeta_values));
total = length(nu_values)*length(zeta_values);
count = 1;

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
        t = 0:0.01:30;
        y = step(G, t);
        K = y(end);
                
        % Z-N params
        [Gm, Pm, Wcg, Wcp] = margin(G);
        Kcr = Gm; %bc K = 1
        Pcr = 2 * pi / Wcg;
        
        if Gm >= 1e4
            fprintf('no Kcr\n')
            ITAE(i, j) = NaN;
            fprintf('%.i/%.i\n', count, total)
            count = count+1;
            continue
        end
                
        % PID
        Kp = 0.6*Kcr;
        Ti = 0.5*Pcr;
        Td = Pcr/8;
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