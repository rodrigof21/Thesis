load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PSO_data.mat")

nu   = PSO_data(:, 1);
zeta = PSO_data(:, 2);
Kp   = PSO_data(:, 3);
Ki   = PSO_data(:, 4);
Kd   = PSO_data(:, 5);
Tf   = PSO_data(:, 6);

% Kp Model
X = [nu, zeta];
[fit_kp, gof_kp] = fit(X, log(Kp), 'Poly44');
fprintf('Kp R^2 = %.4f\n', gof_kp.rsquare)
% figure, plot(fit_kp, X, Kp)
% title('Kp')

% Ki Model
[fit_ki, gof_ki] = fit(X, log(Ki), 'Poly44');
fprintf('Ki R^2 = %.4f\n', gof_ki.rsquare)
% figure, plot(fit_ki, X, Ki)
% title('Ki')

% Kd Model
[fit_kd, gof_kd] = fit(X, log(Kd), 'Poly44');
fprintf('Kd R^2 = %.4f\n', gof_kd.rsquare)
% figure, plot(fit_kd, X, Kd)
% title('Kd')

% Tf Model
[fit_tf, gof_tf] = fit(X, Tf, 'Poly44');
fprintf('Tf R^2 = %.4f\n', gof_tf.rsquare)
% figure, plot(fit_tf, X, Tf)
% title('Tf')

PID_Models = struct('fit_Kp', fit_kp, 'fit_Ki', fit_ki, 'fit_Kd', fit_kd, 'fit_Tf', fit_tf, ...
                    'gof_Kp', gof_kp, 'gof_Ki', gof_ki, 'gof_Kd', gof_kd, 'gof_Tf', gof_tf);

pasta_destino = "C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PID_Models.mat";

save(pasta_destino, 'PID_Models');

fprintf('---------------\n')



% Validation

% random point
% nu = min(nu) + rand() * (max(nu) - min(nu));
% zeta = min(zeta) + rand() * (max(zeta) - min(zeta));
nu = 1.9;
zeta = 1.7;
nu_test = nu;
zeta_test = zeta;
wn = 1;

fprintf('\n--- random test ---\n');
fprintf('params: nu = %.3f | zeta = %.3f\n', nu_test, zeta_test);

% gains 
Kp_calc = exp(fit_kp(nu_test, zeta_test));
Ki_calc = exp(fit_ki(nu_test, zeta_test));
Kd_calc = exp(fit_kd(nu_test, zeta_test));
Tf_calc = (fit_tf(nu_test, zeta_test));


fprintf('gains:\n');
fprintf('Kp = %.2f | Ki = %.2f | Kd = %.2f | Tf = %.2f\n', Kp_calc, Ki_calc, Kd_calc, Tf_calc);

G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);

% controller
num_coefs = [(Kp_calc/Tf_calc + Kd_calc), (Kp_calc + Ki_calc/Tf_calc), Ki_calc];
den_coefs = [1/Tf_calc, 1];
C = fotf(den_coefs, [2, 1], num_coefs, [2, 1, 0]);

T = feedback(C*G, 1);

t_sim = 0:0.01:100;

figure('Name', 'Validação do Modelo Analítico', 'Position', [200, 200, 800, 500]);
hold on; grid on;

y_open = step(G, t_sim);
plot(t_sim, y_open, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Não Controlado');

y_closed = step(T, t_sim);
plot(t_sim, y_closed, 'b-', 'LineWidth', 2, 'DisplayName', 'Controlado');

yline(1, 'k:', 'Referência', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

title(sprintf('step response (\\nu = %.3f, \\zeta = %.3f)', nu_test, zeta_test));
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('Location', 'best');

% fprintf('\n%% ==================================================\n');
% fprintf('%% --- CÓDIGO LATEX PARA COPIAR PARA O OBSIDIAN ---\n');
% fprintf('%% ==================================================\n\n');
% 
% % Extrair os valores otimizados
% v_kp = coeffvalues(fit_kp);
% v_ki = coeffvalues(fit_ki);
% v_kd = coeffvalues(fit_kd);
% subs = {'00', '10', '01', '20', '11', '02', '30', '21', '12', '03', '40', '31', '22', '13', '04'};
% 
% % --- MODELO Kp (Letra i) ---
% fprintf('$$\n\\begin{aligned}\n');
% fprintf('\\ln K_p(\\nu, \\zeta) = & \\, i_{00} + i_{10}\\nu + i_{01}\\zeta + i_{20}\\nu^2 + i_{11}\\nu\\zeta + i_{02}\\zeta^2 \\\\\n');
% fprintf('& + i_{30}\\nu^3 + i_{21}\\nu^2\\zeta + i_{12}\\nu\\zeta^2 + i_{03}\\zeta^3 \\\\\n');
% fprintf('& + i_{40}\\nu^4 + i_{31}\\nu^3\\zeta + i_{22}\\nu^2\\zeta^2 + i_{13}\\nu\\zeta^3 + i_{04}\\zeta^4\n');
% fprintf('\\end{aligned}\n$$\n\n');
% 
% % --- MODELO Ki (Letra j) ---
% fprintf('$$\n\\begin{aligned}\n');
% fprintf('\\ln K_i(\\nu, \\zeta) = & \\, j_{00} + j_{10}\\nu + j_{01}\\zeta + j_{20}\\nu^2 + j_{11}\\nu\\zeta + j_{02}\\zeta^2 \\\\\n');
% fprintf('& + j_{30}\\nu^3 + j_{21}\\nu^2\\zeta + j_{12}\\nu\\zeta^2 + j_{03}\\zeta^3 \\\\\n');
% fprintf('& + j_{40}\\nu^4 + j_{31}\\nu^3\\zeta + j_{22}\\nu^2\\zeta^2 + j_{13}\\nu\\zeta^3 + j_{04}\\zeta^4\n');
% fprintf('\\end{aligned}\n$$\n\n');
% 
% % --- MODELO Kd (Letra k) ---
% fprintf('$$\n\\begin{aligned}\n');
% fprintf('\\ln K_d(\\nu, \\zeta) = & \\, k_{00} + k_{10}\\nu + k_{01}\\zeta + k_{20}\\nu^2 + k_{11}\\nu\\zeta + k_{02}\\zeta^2 \\\\\n');
% fprintf('& + k_{30}\\nu^3 + k_{21}\\nu^2\\zeta + k_{12}\\nu\\zeta^2 + k_{03}\\zeta^3 \\\\\n');
% fprintf('& + k_{40}\\nu^4 + k_{31}\\nu^3\\zeta + k_{22}\\nu^2\\zeta^2 + k_{13}\\nu\\zeta^3 + k_{04}\\zeta^4\n');
% fprintf('\\end{aligned}\n$$\n\n');
% 
% % --- TABELA DE COEFICIENTES ---
% fprintf('Valores dos coeficientes:\n');
% fprintf('$$\n\\begin{aligned}\n');
% for idx = 1:15
%     fprintf('%s_{%s} &= %10.4f & %s_{%s} &= %10.4f & %s_{%s} &= %10.4f \\\\\n', ...
%         'i', subs{idx}, v_kp(idx), ...
%         'j', subs{idx}, v_ki(idx), ...
%         'k', subs{idx}, v_kd(idx));
% end
% fprintf('\\end{aligned}\n$$\n');