load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PSO_data_withTf.mat")
nu_raw   = PSO_data(:, 1);
zeta_raw = PSO_data(:, 2);

nu_vals = linspace(min(nu_raw), max(nu_raw), 50);
zeta_vals = linspace(min(zeta_raw), max(zeta_raw), 50);
[Nu_grid, Zeta_grid] = meshgrid(nu_vals, zeta_vals);

function [X_clean, Y_clean] = smooth_surface(x, y, z, X_grid, Y_grid)

    F = scatteredInterpolant(x, y, z, 'natural', 'none');
    Z_grid = F(X_grid, Y_grid);
    Z_smooth = smoothdata2(Z_grid, 'gaussian', 5);
    
    X_clean = [X_grid(:), Y_grid(:)];
    Y_clean = Z_smooth(:);
    
    validos = ~isnan(Y_clean);
    X_clean = X_clean(validos, :);
    Y_clean = Y_clean(validos);
end

[X_kp, Kp_clean] = smooth_surface(nu_raw, zeta_raw, PSO_data(:, 3), Nu_grid, Zeta_grid);
[X_ki, Ki_clean] = smooth_surface(nu_raw, zeta_raw, PSO_data(:, 4), Nu_grid, Zeta_grid);
[X_kd, Kd_clean] = smooth_surface(nu_raw, zeta_raw, PSO_data(:, 5), Nu_grid, Zeta_grid);
[X_tf, Tf_clean] = smooth_surface(nu_raw, zeta_raw, PSO_data(:, 6), Nu_grid, Zeta_grid);


opts = fitoptions('poly44');

[fit_kp, gof_kp] = fit(X_kp, Kp_clean, 'Poly44', opts);
fprintf('NOVO Kp R^2 = %.4f\n', gof_kp.rsquare)

[fit_ki, gof_ki] = fit(X_ki, Ki_clean, 'Poly44', opts);
fprintf('NOVO Ki R^2 = %.4f\n', gof_ki.rsquare)

[fit_kd, gof_kd] = fit(X_kd, Kd_clean, 'Poly44', opts);
fprintf('NOVO Kd R^2 = %.4f\n', gof_kd.rsquare)

[fit_tf, gof_tf] = fit(X_tf, Tf_clean, 'Poly44', opts);
fprintf('NOVO Tf R^2 = %.4f\n', gof_tf.rsquare)

figure;
subplot(2,2,1); plot(fit_kp, X_kp, Kp_clean); title('Kp Smooth');
subplot(2,2,2); plot(fit_ki, X_ki, Ki_clean); title('Ki Smooth');
subplot(2,2,3); plot(fit_kd, X_kd, Kd_clean); title('Kd Smooth');
subplot(2,2,4); plot(fit_tf, X_tf, Tf_clean); title('Tf Smooth');


PID_Models = struct('fit_Kp', fit_kp, 'fit_Ki', fit_ki, 'fit_Kd', fit_kd, 'fit_Tf', fit_tf, ...
                    'gof_Kp', gof_kp, 'gof_Ki', gof_ki, 'gof_Kd', gof_kd, 'gof_Tf', gof_tf);

pasta_destino = "C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models_smoothsurface.mat";

save(pasta_destino, 'PID_Models');
%disp('Struct com os modelos guardada com sucesso!');


% Validation

% nu_test = min(nu_raw) + rand() * (max(nu_raw) - min(nu_raw));
% zeta_test = min(zeta_raw) + rand() * (max(zeta_raw) - min(zeta_raw));
nu_test = 1.6;
zeta_test = 0.6;
nu = nu_test;
zeta = zeta_test;

wn = 1;


fprintf('\n--- TESTE ALEATÓRIO DE VALIDAÇÃO ---\n');
fprintf('params: nu = %.3f | zeta = %.3f\n', nu_test, zeta_test);

Kp_calc = fit_kp(nu_test, zeta_test);
Ki_calc = fit_ki(nu_test, zeta_test);
Kd_calc = fit_kd(nu_test, zeta_test);
Tf_calc = fit_tf(nu_test, zeta_test);

if Kp_calc < 0
    Kp_calc = 0;
end

fprintf('gains:\n');
fprintf('Kp = %.2f | Ki = %.2f | Kd = %.2f | Tf = %.2f\n', Kp_calc, Ki_calc, Kd_calc, Tf_calc);

G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);

num_coefs = [(Kp_calc/Tf_calc + Kd_calc), (Kp_calc + Ki_calc/Tf_calc), Ki_calc];
den_coefs = [1/Tf_calc, 1];
C = fotf(den_coefs, [2, 1], num_coefs, [2, 1, 0]);

T = feedback(C*G, 1);

t_sim = 0:0.01:30;

figure('Name', 'Validação do Modelo Analítico', 'Position', [200, 200, 800, 500]);
hold on; grid on;

y_open = step(G, t_sim);
plot(t_sim, y_open, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Não Controlado (Malha Aberta)');

y_closed = step(T, t_sim);
plot(t_sim, y_closed, 'b-', 'LineWidth', 2, 'DisplayName', 'Controlado (Polinómio 44)');

yline(1, 'k:', 'Referência', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

title(sprintf('Comparação de Resposta ao Degrau (\\nu = %.3f, \\zeta = %.3f)', nu_test, zeta_test));
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('Location', 'best');


