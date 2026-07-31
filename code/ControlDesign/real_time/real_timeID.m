
% initial defs
wn = 1;
ts = 0.5;
t = 0:ts:60;

nu_vec = 0.7:0.1:1.9;
zeta_vec = 0.1:0.1:5;

rng(42);
RMS = zeros(length(nu_vec), length(zeta_vec));

total = length(nu_vec)* length(zeta_vec);
count = 1;

for i = 1:length(nu_vec)
    for j = 1:length(zeta_vec)

        nu = nu_vec(i);
        zeta = zeta_vec(j);

        is_stable = checkStability(nu, zeta);
        if ~is_stable
            RMS(i, j) = Inf;
            fprintf('Unstable\n');
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end

        % continuous time G
        G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
        u = ones(length(t), 1);
        y_clean = step(G, t); 

        % Add noise
        noise_level = 0.01;
        noise = noise_level * randn(size(y_clean));
        y = y_clean + noise;
        
        % ARX parameters
        theta = zeros(4, 1);
        r = eye(4)*0.1; 
        theta_hist = zeros(4, length(y)); 
        y_id_online = zeros(length(y), 1);
        
        % ID cycle
        for k = 1:length(y)
        
        
            if k == 1
                uk_1 = 0; yk_1 = 0; yk_2 = 0;
            elseif k == 2
                uk_1 = u(1); yk_1 = y(1); yk_2 = 0;
            else
                uk_1 = u(k-1); yk_1 = y(k-1); yk_2 = y(k-2);
            end
            
            a_k = [u(k); uk_1; -yk_1; -yk_2];
                  
            y_guess_antigo = theta' * a_k;
            err = y(k) - y_guess_antigo;
            
            
            [theta, r] = online_ID(theta, r, a_k, err);
            
            % estimativa
            y_id_online(k) = theta' * a_k;

        end

        error = y - y_id_online;
        RMS(i, j) = sqrt(mean(error.^2));

        fprintf('%.i / %.i\n', count, total);
        count = count+1;
    end
end

open RMS

% % plots
% figure
% plot(t, y, 'b')
% hold on
% plot(t, y_id_online, 'r') 
% legend('original', 'identificado', 'location', 'best')
% xlabel('tempo')
% ylabel('amplitude')
% grid on

function [theta,R] = online_ID(theta_old, R_old, a, err)
    % forgetting factor
    alpha = 1;
    R = R_old + alpha*(a*a');
    theta = theta_old + alpha*(R\a)*err;
end