% PSO for FOPID without Tf (Tf will be computed later)


nu_values = 0.7:0.2:1.9;
zeta_values = 0:0.2:5;

% nu_values = 1.4;
% zeta_values = 0.6;

ITAE = zeros(length(nu_values), length(zeta_values));
total = length(nu_values)*length(zeta_values);
count = 1;

gains = zeros(length(nu_values), length(zeta_values), 4);
exps  = zeros(length(nu_values), length(zeta_values), 2);

FOPSO_data = zeros(total, 7); 
valid_count = 0;

for i = 1:length(nu_values)
    for j = 1:length(zeta_values)

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
        
        % Step response data
        t = 0:0.05:30;
        y = step(G, t);
        K = 1;
        
        num_vars = 5;
        lb = [0.01, 0.001, 0.001, 0.1, 0.1];
        ub = [100, 100, 100, 1.9, 1.9];

        % pso_options = optimoptions('particleswarm', 'Display', 'iter', ...
        %                       'SwarmSize', 10, 'MaxIterations', 10);
        
        if nu > 1.2
            S_size = 30; Max_iter = 30;
        else
            S_size = 10; Max_iter = 10;
        end
        
        if valid_count > 0 && j > 1
            pso_options = optimoptions('particleswarm', 'Display', 'iter', ...
                'SwarmSize', S_size, 'MaxIterations', Max_iter, ...
                'InitialSwarmMatrix', gains_now);
        else
            pso_options = optimoptions('particleswarm', 'Display', 'iter', ...
                'SwarmSize', S_size, 'MaxIterations', Max_iter);
        end
            

        obj_fun = @(x) calc_cost(x, G, t);
        
        [gains_now, ITAE(i, j)] = particleswarm(obj_fun, num_vars, lb, ub, pso_options);
        Kp = gains_now(1); Ki = gains_now(2); 
        Kd = gains_now(3); 
        lambda = gains_now(4);
        mu = gains_now(5);

        gains(i, j, 1) = Kp; gains(i, j, 2) = Ki; 
        gains(i, j, 3) = Kd;
        exps(i, j, 1) = lambda; exps(i, j, 2) = mu;

        valid_count = valid_count + 1;
        FOPSO_data(valid_count, :) = [nu, zeta, Kp, Ki, Kd, lambda, mu];
        
        
        fprintf('%.i/%.i\n', count, total)
        count = count+1;
    end
end

FOPSO_data = FOPSO_data(1:valid_count, :);

% % For one step only
% Kp = gains(1); Ki = gains(2); Kd = gains(3);
% 
% C = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]);
% 
% T = feedback(C*G, 1);
% figure, step(T, t), hold on
% step(G, t)
% 
% coef_1 = 1 / (wn^(nu+1));
% ord_1 = nu + 1;
% coef_2 = (2*zeta) / (wn^nu);
% ord_2 = nu;
% str_polos = sprintf('%g*s^%g + %g*s^%g + 1', coef_1, ord_1, coef_2, ord_2);
% set_param('PID_arch/Controlled FTF','polePoly', str_polos);
% set_param('PID_arch/Free FTF','polePoly', str_polos);

function cost = calc_cost(x, G_plant, t_sim)
    
    Kp = x(1); Ki = x(2); Kd = x(3); 
    lambda = x(4); mu = x(5);


    Cp = fotf(1, 0, Kp, 0);
    Ci = fotf(1, lambda, Ki, 0);
    Cd = fotf(1, 0, Kd, mu);
    C = Cp + Ci + Cd;

    
    % num_coefs = [(Kp/Tf + Kd), (Kp + Ki/Tf), Ki];
    % den_coefs = [1/Tf, 1];
    % C = fotf(den_coefs, [2, 1], num_coefs, [2, 1, 0]);

    %C = fotf(1, 1, [Kd, Kp, Ki], [2, 1, 0]);
    
    T = feedback(C*G_plant, 1);
    [y, t_out] = step(T, t_sim);
    
    % failsafe
    if any(isnan(y)) || any(isinf(y)) || max(abs(y)) > 1e4
        cost = 1e6;
        return;
    end

    err = 1 - y;
    itae = trapz(t_out(:), t_out(:) .* abs(err(:)));

    % overshoot penalty
    os = max(0, max(y) - 1); 
    penalty_os = 1000 * os;
       
    % control action penalty
    % U_tf = feedback(C, G_plant);
    % u_signal = step(U_tf, t_out);
    % max_u = max(abs(u_signal));
    % penalty_u = 0.005 * max_u;
    penalty_u = 0.005*(Kp+Kd);

    cost = itae + penalty_os + penalty_u;
end


pasta_destino = "C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\FO_PID\results\FOPSO_Data.mat";

save(pasta_destino, 'FOPSO_data');