%% =========================================================================
%   TREINO DOS MODELOS ESPECIALISTAS E VALIDAÇÃO GLOBAL EM CASCATA
%% =========================================================================

% 1. Carregar dados primitivos
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

toCol = @(x) x(:);
t02  = toCol(results(:, 1)); t05  = toCol(results(:, 2)); t08  = toCol(results(:, 3));
nu   = toCol(results(:, 4)); zeta = toCol(results(:, 5)); t07  = toCol(results(:, 6));
Mp   = toCol(results(:, 7)); tp   = toCol(results(:, 8));  t01  = toCol(results(:, 9));

% Configuração padrão de treino para velocidade e convergência
opts = fitoptions('poly44');
opts.Normalize = 'on';

fprintf('A treinar os 4 modelos especialistas com os resultados do varrimento...\n');

%% === PASSO A: TREINAR POLINÓMIOS PARA O RAMO "COM PICOS" ===
idx_sub = (nu > 0.6 & Mp > 1e-5);

% Nu subamortecido independente: [log(t01/t08), t05/tp]
X_nu_sub = [log(t01(idx_sub)./t08(idx_sub)), t05(idx_sub)./tp(idx_sub)];
Y_nu_sub = nu(idx_sub);
fit_nu_sub = fit(X_nu_sub, Y_nu_sub, 'poly44', opts);

% Zeta subamortecido dependente de nu_real (no treino usa-se o real)
X_zeta_sub = [log(t01(idx_sub)./tp(idx_sub)), nu(idx_sub)];
Y_zeta_sub = zeta(idx_sub);
fit_zeta_sub = fit(X_zeta_sub, Y_zeta_sub, 'poly44', opts);


%% === PASSO B: TREINAR POLINÓMIOS PARA O RAMO "SEM PICOS" ===
idx_sobre = (nu > 0.6 & Mp <= 1e-5);

% Nu sobreamortecido independente: [t07/t08, log((t08-t05)/(t02-t01))]
X_nu_sobre = [t07(idx_sobre)./t08(idx_sobre), log((t08(idx_sobre)-t05(idx_sobre))./(t02(idx_sobre)-t01(idx_sobre)))];
Y_nu_sobre = nu(idx_sobre);
fit_nu_sobre = fit(X_nu_sobre, Y_nu_sobre, 'poly44', opts);

% Zeta sobreamortecido dependente de nu_real
X_zeta_sobre = [log(t01(idx_sobre)./t02(idx_sobre)), nu(idx_sobre)];
Y_zeta_sobre = zeta(idx_sobre);
fit_zeta_sobre = fit(X_zeta_sobre, Y_zeta_sobre, 'poly44', opts);

fprintf('Treino concluído com sucesso. A iniciar simulação de teste...\n\n');


%% =========================================================================
%   2. LOOP DE VALIDAÇÃO (MÉTODO EM CASCATA COM PROPAGAÇÃO DE ERRO)
%% =========================================================================

% Filtrar apenas o range útil global para o teste (nu > 0.6)
idx_global = nu > 0.6;
N_pontos = sum(idx_global);

% Isolar dados de teste filtrados
t01_t = t01(idx_global); t02_t = t02(idx_global); t05_t = t05(idx_global);
t07_t = t07(idx_global); t08_t = t08(idx_global); tp_t  = tp(idx_global);
Mp_t  = Mp(idx_global);
nu_real_vector   = nu(idx_global);
zeta_real_vector = zeta(idx_global);

nu_pred   = zeros(N_pontos, 1);
zeta_pred = zeros(N_pontos, 1);

for k = 1:N_pontos
    
    % Dados do ponto atual
    Mp_k  = Mp_t(k);  tp_k  = tp_t(k);  t01_k = t01_t(k);
    t02_k = t02_t(k); t05_k = t05_t(k); t07_k = t07_t(k); t08_k = t08_t(k);
    
    % Decisão baseada na presença física de pico
    if Mp_k > 1e-5
        %% Ramo Subamortecido
        X1_nu = log(t01_k / t08_k);
        X2_nu = t05_k / tp_k;
        nu_estimado = feval(fit_nu_sub, X1_nu, X2_nu);
        nu_pred(k)  = nu_estimado;
        
        % O zeta_sub recebe o nu_estimado (propagação de erro real!)
        X1_zeta = log(t01_k / tp_k);
        X2_zeta = nu_estimado; 
        zeta_pred(k) = feval(fit_zeta_sub, X1_zeta, X2_zeta);
    else
        %% Ramo Sobreamortecido
        X1_nu = t07_k / t08_k;
        X2_nu = log((t08_k - t05_k) / (t02_k - t01_k));
        nu_estimado = feval(fit_nu_sobre, X1_nu, X2_nu);
        nu_pred(k)  = nu_estimado;
        
        % O zeta_sobre recebe o nu_estimado
        X1_zeta = log(t01_k / t02_k);
        X2_zeta = nu_estimado;
        zeta_pred(k) = feval(fit_zeta_sobre, X1_zeta, X2_zeta);
    end
end

%% =========================================================================
%   3. CÁLCULO E APRESENTAÇÃO DAS MÉTRICAS DE ERRO
%% =========================================================================

erro_nu   = abs(nu_real_vector - nu_pred);
erro_zeta = abs(zeta_real_vector - zeta_pred);

% Métricas individuais
erro_medio_nu = mean(erro_nu);   erro_max_nu = max(erro_nu);     rms_nu = sqrt(mean(erro_nu.^2));
erro_medio_zeta = mean(erro_zeta); erro_max_zeta = max(erro_zeta); rms_zeta = sqrt(mean(erro_zeta.^2));

% Métrica combinada de erro quadrático por ponto
rms_global_ponto = sqrt(0.5 * (erro_nu.^2 + erro_zeta.^2));
rms_medio_global = mean(rms_global_ponto);
rms_max_global   = max(rms_global_ponto);

fprintf('===================================================\n');
fprintf('     RELATÓRIO DE DESEMPENHO DO MODELO EM CASCATA    \n');
fprintf('===================================================\n');
fprintf('  [ PARÂMETRO NU (Ordem Fracionária) ]\n');
fprintf('    Erro Médio Absoluto:  %.5f\n', erro_medio_nu);
fprintf('    Erro Máximo Absoluto:  %.5f\n', erro_max_nu);
fprintf('    Erro RMS do Parâmetro: %.5f\n', rms_nu);
fprintf('---------------------------------------------------\n');
fprintf('  [ PARÂMETRO ZETA (Amortecimento) ]\n');
fprintf('    Erro Médio Absoluto:  %.5f\n', erro_medio_zeta);
fprintf('    Erro Máximo Absoluto:  %.5f\n', erro_max_zeta);
fprintf('    Erro RMS do Parâmetro: %.5f\n', rms_zeta);
fprintf('---------------------------------------------------\n');
fprintf('  [ MÉTRICAS GLOBAIS DE ERRO DO MODELO ]\n');
fprintf('    Erro RMS Médio Global: %.5f\n', rms_medio_global);
fprintf('    Erro RMS Máximo Global: %.5f\n', rms_max_global);
fprintf('===================================================\n');