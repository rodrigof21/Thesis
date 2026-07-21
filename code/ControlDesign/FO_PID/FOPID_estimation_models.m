load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\FO_PID\results\FOPSO_data.mat")

nu     = FOPSO_data(:, 1);
zeta   = FOPSO_data(:, 2);
Kp     = FOPSO_data(:, 3);
Ki     = FOPSO_data(:, 4);
Kd     = FOPSO_data(:, 5);
lambda = FOPSO_data(:, 6);
mu     = FOPSO_data(:, 7);

% Kp Model
X = [nu, zeta];
[fit_kp, gof_kp] = fit(X, (Kp), 'Poly53');
fprintf('Kp R^2 = %.4f\n', gof_kp.rsquare)
% figure, plot(fit_kp, X, Kp)
% title('Kp')

% Ki Model
[fit_ki, gof_ki] = fit(X, log(Ki), 'Poly52');
fprintf('Ki R^2 = %.4f\n', gof_ki.rsquare)
% figure, plot(fit_ki, X, log(Ki))
% title('Ki')

% Kd Model
[fit_kd, gof_kd] = fit(X, (Kd), 'Poly54');
fprintf('Kd R^2 = %.4f\n', gof_kd.rsquare)
% figure, plot(fit_kd, X, Kd)
% title('Kd')

% Lambda Model
[fit_lam, gof_lam] = fit(X, lambda, 'Poly53');
fprintf('lambda R^2 = %.4f\n', gof_lam.rsquare)
% figure, plot(fit_lam, X, lambda)
% title('Lambda')

% mu Model
[fit_mu, gof_mu] = fit(X, mu, 'Poly52');
fprintf('mu R^2 = %.4f\n', gof_mu.rsquare)
% figure, plot(fit_mu, X, mu)
% title('mu')

FOPID_Models = struct('fit_Kp', fit_kp, 'fit_Ki', fit_ki, 'fit_Kd', fit_kd, 'fit_lam', fit_lam, 'fit_mu', fit_mu, ...
                    'gof_Kp', gof_kp, 'gof_Ki', gof_ki, 'gof_Kd', gof_kd, 'gof_lam', gof_lam, 'gof_mu', gof_mu);

pasta_destino = "C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\FO_PID\results\FOPID_Models.mat";

save(pasta_destino, 'FOPID_Models');

fprintf('---------------\n')




%% Plots one curve
% % Validation
% 
% % random point
% % nu = min(nu) + rand() * (max(nu) - min(nu));
% % zeta = min(zeta) + rand() * (max(zeta) - min(zeta));
% nu = 1.9;
% zeta = 1.7;
% nu_test = nu;
% zeta_test = zeta;
% wn = 1;
% 
% fprintf('\n--- random test ---\n');
% fprintf('params: nu = %.3f | zeta = %.3f\n', nu_test, zeta_test);
% 
% % gains 
% Kp_calc = exp(fit_kp(nu_test, zeta_test));
% Ki_calc = exp(fit_ki(nu_test, zeta_test));
% Kd_calc = exp(fit_kd(nu_test, zeta_test));
% Tf_calc = (fit_tf(nu_test, zeta_test));
% 
% 
% fprintf('gains:\n');
% fprintf('Kp = %.2f | Ki = %.2f | Kd = %.2f | Tf = %.2f\n', Kp_calc, Ki_calc, Kd_calc, Tf_calc);
% 
% G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
% 
% % controller
% num_coefs = [(Kp_calc/Tf_calc + Kd_calc), (Kp_calc + Ki_calc/Tf_calc), Ki_calc];
% den_coefs = [1/Tf_calc, 1];
% C = fotf(den_coefs, [2, 1], num_coefs, [2, 1, 0]);
% 
% T = feedback(C*G, 1);
% 
% t_sim = 0:0.01:100;
% 
% figure('Name', 'Validação do Modelo Analítico', 'Position', [200, 200, 800, 500]);
% hold on; grid on;
% 
% y_open = step(G, t_sim);
% plot(t_sim, y_open, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Não Controlado');
% 
% y_closed = step(T, t_sim);
% plot(t_sim, y_closed, 'b-', 'LineWidth', 2, 'DisplayName', 'Controlado');
% 
% yline(1, 'k:', 'Referência', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
% 
% title(sprintf('step response (\\nu = %.3f, \\zeta = %.3f)', nu_test, zeta_test));
% xlabel('Tempo (s)');
% ylabel('Amplitude');
% legend('Location', 'best');







%% Equaçoes LATEX
% % =========================================================================
% % GERADOR DE CÓDIGO LATEX PARA OBSIDIAN (EQUAÇÕES + TABELA DE COEFICIENTES)
% % =========================================================================
% 
% % 1. Estruturar os modelos e as suas respetivas letras
% models = {fit_kp, fit_ki, fit_kd, fit_lam, fit_mu};
% letters = {'a', 'b', 'c', 'd', 'e'};
% param_names = {'K_p(\nu, \zeta)', '\ln\big(K_i(\nu, \zeta)\big)', 'K_d(\nu, \zeta)', '\lambda(\nu, \zeta)', '\mu(\nu, \zeta)'};
% 
% % Extrair informação de cada modelo
% max_coeffs = 0;
% all_coeffs = cell(1, 5);
% all_names = cell(1, 5);
% 
% for m = 1:5
%     c_names = coeffnames(models{m});
%     c_vals = coeffvalues(models{m})';
% 
%     % Traduzir nomes 'p21' -> 'a_{21}', 'p00' -> 'a_{00}'
%     latex_indices = cell(length(c_names), 1);
%     for k = 1:length(c_names)
%         idx_str = c_names{k}(2:end); % remove o 'p' do matlab
%         if length(idx_str) == 1
%             idx_str = ['0' idx_str]; % caso de p1 -> p01
%         end
%         latex_indices{k} = sprintf('%s_{%s}', letters{m}, idx_str);
%     end
% 
%     all_coeffs{m} = c_vals;
%     all_names{m} = latex_indices;
%     if length(c_vals) > max_coeffs
%         max_coeffs = length(c_vals);
%     end
% end
% 
% 
%
% % =========================================================================
% % 1. GERAR EQUAÇÕES POR EXTENSO (PARA COLAR NO OBSIDIAN)
% % =========================================================================
% fprintf('\n%% =========================================================\n');
% fprintf('%% EQUAÇÕES POR EXTENSO (COPIAR PARA O OBSIDIAN):\n');
% fprintf('%% =========================================================\n\n');
% fprintf('$$\n\\begin{aligned}\n');
% 
% for m = 1:5
%     c_names = coeffnames(models{m});
%     c_vals = coeffvalues(models{m})';
% 
%     eq_str = sprintf('    %s &= ', param_names{m});
% 
%     for k = 1:length(c_vals)
%         val = c_vals(k);
%         idx_str = c_names{k}(2:end);
%         if length(idx_str) == 1, idx_str = ['0' idx_str]; end
% 
%         % Determinar sinal e operador
%         if val >= 0
%             if k == 1, sign_str = ''; else, sign_str = ' + '; end
%         else
%             if k == 1, sign_str = '-'; else, sign_str = ' - '; end
%         end
% 
%         % Determinar variáveis nu e zeta baseado no índice pIJ
%         i_pow = str2double(idx_str(1));
%         j_pow = str2double(idx_str(2));
% 
%         var_str = '';
%         if i_pow == 1, var_str = [var_str '\nu ']; elseif i_pow > 1, var_str = [var_str sprintf('\\nu^%d ', i_pow)]; end
%         if j_pow == 1, var_str = [var_str '\zeta ']; elseif j_pow > 1, var_str = [var_str sprintf('\\zeta^%d ', j_pow)]; end
% 
%         % Adicionar termo à equação
%         eq_str = [eq_str sprintf('%s%.4g\\, %s_%s\\, %s', sign_str, abs(val), letters{m}, idx_str, var_str)];
%     end
%     eq_str = [eq_str '\\\\'];
%     fprintf('%s\n', eq_str);
% end
% fprintf('\\end{aligned}\n$$\n');
% 
% % =========================================================================
% % 2. GERAR TABELA DE COEFICIENTES EM LATEX
% % =========================================================================
% fprintf('\n%% =========================================================\n');
% fprintf('%% TABELA DE COEFICIENTES (COPIAR PARA O OBSIDIAN / LATEX):\n');
% fprintf('%% =========================================================\n\n');
% 
% fprintf('\\begin{table}[htbp]\n');
% fprintf('    \\centering\n');
% fprintf('    \\caption{Estimated values for the fractional PID polynomial coefficients ($a_{ij}$ to $e_{ij}$).}\n');
% fprintf('    \\label{tab:fopid_coefficients}\n');
% fprintf('    \\begin{tabular}{cr cr cr cr cr}\n');
% fprintf('        \\toprule\n');
% fprintf('        \\textbf{Coeff.} & \\textbf{Value} & \\textbf{Coeff.} & \\textbf{Value} & \\textbf{Coeff.} & \\textbf{Value} & \\textbf{Coeff.} & \\textbf{Value} & \\textbf{Coeff.} & \\textbf{Value} \\\\\n');
% fprintf('        \\midrule\n');
% 
% for r = 1:max_coeffs
%     row_str = '        ';
%     for m = 1:5
%         if r <= length(all_coeffs{m})
%             c_name = all_names{m}{r};
%             c_val = all_coeffs{m}(r);
%             % Formatar valor (notação científica se for muito grande/pequeno)
%             if abs(c_val) >= 1e4 || (abs(c_val) < 1e-3 && c_val ~= 0)
%                 val_str = sprintf('$%.3e$', c_val);
%                 val_str = strrep(val_str, 'e', '\\times 10^{');
%                 val_str = strrep(val_str, '+0', '');
%                 val_str = strrep(val_str, '-0', '-');
%                 val_str = [val_str '}'];
%             else
%                 val_str = sprintf('$%.4f$', c_val);
%             end
%             col_str = sprintf('$%s$ & %s', c_name, val_str);
%         else
%             col_str = ' & '; % Célula vazia se este polinómio tiver menos termos
%         end
% 
%         if m < 5
%             row_str = [row_str col_str ' & '];
%         else
%             row_str = [row_str col_str ' \\\\'];
%         end
%     end
%     fprintf('%s\n', row_str);
% end
% 
% fprintf('        \\bottomrule\n');
% fprintf('    \\end{tabular}\n');
% fprintf('\\end{table}\n');