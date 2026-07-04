load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models.mat")

nu_values = 0.7:0.2:1.9;
zeta_values = 0:0.2:5;


ITAE = zeros(length(nu_values), length(zeta_values));
total = length(nu_values)*length(zeta_values);
count = 1;

Tf_matrix = zeros(length(nu_values), length(zeta_values));

PSO_data_Tf = zeros(total, 6); 
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
        t = 0:0.01:30;
        y = step(G, t);
        K = 1;
        
        num_vars = 1;
        lb = 1;
        ub = 100;
        

        % if nu > 1.2
        %     S_size = 30; Max_iter = 30;
        % else
        %     S_size = 10; Max_iter = 10;
        % end

        S_size = 10; Max_iter = 10;
        
        if valid_count > 0 && j > 1
            pso_options = optimoptions('particleswarm', 'Display', 'iter', ...
                'SwarmSize', S_size, 'MaxIterations', Max_iter, ...
                'InitialSwarmMatrix', Tf);
        else
            pso_options = optimoptions('particleswarm', 'Display', 'iter', ...
                'SwarmSize', S_size, 'MaxIterations', Max_iter);
        end

        Kp = exp(PID_Models.fit_Kp(nu, zeta));
        Ki = exp(PID_Models.fit_Ki(nu, zeta));
        Kd = exp(PID_Models.fit_Kd(nu, zeta));
        
        gainsK = [Kp, Ki, Kd];
        
        obj_fun = @(x) calc_cost(x, G, t, gainsK);

        
        [Tf_now, ITAE(i, j)] = particleswarm(obj_fun, num_vars, lb, ub, pso_options);

        Tf_matrix(i, j) = Tf_now;

        valid_count = valid_count + 1;
        PSO_data_Tf(valid_count, :) = [nu, zeta, Kp, Ki, Kd, Tf];
        
        
        fprintf('%.i/%.i\n', count, total)
        count = count+1;
    end
end

PSO_data_Tf = PSO_data_Tf(1:valid_count, :);

function cost = calc_cost(x, G_plant, t_sim, gains)
    
    Kp = gains(1); Ki = gains(2); 
    Kd = gains(3); Tf = x;

    
    num_coefs = [(Kp/Tf + Kd), (Kp + Ki/Tf), Ki];
    den_coefs = [1/Tf, 1];
    
    C = fotf(den_coefs, [2, 1], num_coefs, [2, 1, 0]);

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
    U_tf = feedback(C, G_plant);
    u_signal = step(U_tf, t_out);
    
    max_u = max(abs(u_signal));
    penalty_u = 0.005 * max_u;

    cost = itae + penalty_os + penalty_u;
end