%% =========================================================================
%   SUPER-VARRIMENTO COMBINATÓRIO ATUALIZADO (INCLUI t09, t95, t99 E RAMOS NU)
%% =========================================================================
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;
toCol = @(x) x(:);

t02  = toCol(results(:, 1));  t05  = toCol(results(:, 2));  t08  = toCol(results(:, 3));
nu   = toCol(results(:, 4));  zeta = toCol(results(:, 5));  t07  = toCol(results(:, 6));
Mp   = toCol(results(:, 7));  tp   = toCol(results(:, 8));   t01  = toCol(results(:, 9));
t09  = toCol(results(:, 10)); t95  = toCol(results(:, 11)); t99  = toCol(results(:, 12));

warning('off', 'curvefit:fit:equationBadlyConditioned');
warning('off', 'curvefit:fit:perfectFit');

% --- DEFINIÇÃO DOS CENÁRIOS (Expandido com Segmentação de Nu) ---
cenarios = { ...
    'Global (Todo o Espetro)',          (nu > 0.6); ...
    'Com Picos (Mp > 1e-5)',           (nu > 0.6 & Mp > 1e-5); ...
    'Sem Picos (Mp <= 1e-5)',          (nu > 0.6 & Mp <= 1e-5); ...
    'Zeta < 2',                         (nu > 0.6 & zeta < 2); ...
    'Zeta >= 2',                        (nu > 0.6 & zeta >= 2); ...
    'Nu < 1.2 (Ordens Baixas)',         (nu > 0.6 & nu < 1.2); ...
    'Nu >= 1.2 (Ordens Altas)',         (nu >= 1.2) ...
};

for c = 1:size(cenarios,1)
    c_name = cenarios{c,1};
    idx = cenarios{c,2};
    
    fprintf('========================================================================\n');
    fprintf('  A PROCESSAR CENÁRIO: %s (Pontos Totais Filtrados: %d)\n', upper(c_name), sum(idx));
    fprintf('========================================================================\n');
    
    if sum(idx) < 50, fprintf('Poucos pontos. A saltar...\n'); continue; end
    
    %% --- CONSTRUÇÃO DINÂMICA DA BIBLIOTECA DE INPUTS ---
    % Nota: Ativação de Mp apenas se houver picos significativos no cenário analisado
    permite_pico = any(Mp(idx) > 1e-5) && ~strcmp(c_name, 'Sem Picos (Mp <= 1e-5)'); 
    
    if permite_pico
        t_vals = [t01, t02, t05, t07, t08, t09, t95, t99, tp];
        t_names = {'t01', 't02', 't05', 't07', 't08', 't09', 't95', 't99', 'tp'};
    else
        t_vals = [t01, t02, t05, t07, t08, t09, t95, t99]; 
        t_names = {'t01', 't02', 't05', 't07', 't08', 't09', 't95', 't99'};
    end
    N_prim = length(t_names);
    
    raw_inputs = {}; raw_names = {};
    
    % A. Rácios Simples
    for i = 1:N_prim
        for j = (i+1):N_prim
            raw_inputs{end+1} = t_vals(:,i) ./ t_vals(:,j);
            raw_names{end+1} = [t_names{i} '/' t_names{j}];
        end
    end
    
    % B. Rácios de Diferenças Críticos
    diffs = { ...
        (t08-t05), ' (t08-t05)'; ...
        (t05-t02), ' (t05-t02)'; ...
        (t02-t01), ' (t02-t01)'; ...
        (t08-t02), ' (t08-t02)'; ...
        (t09-t08), ' (t09-t08)'; ...
        (t99-t95), ' (t99-t95)'  ...
    };
    for i = 1:size(diffs,1)
        for j = (i+1):size(diffs,1)
            raw_inputs{end+1} = diffs{i,1} ./ diffs{j,1};
            raw_names{end+1} = [diffs{i,2} '/' diffs{j,2}];
        end
    end
    
    % Aplicar a transformação LOG
    inputs_valores = {}; inputs_nome = {};
    for k = 1:length(raw_inputs)
        val = raw_inputs{k}; name = raw_names{k};
        inputs_valores{end+1} = val;        inputs_nome{end+1} = name;
        inputs_valores{end+1} = log(val);   inputs_nome{end+1} = ['log(' name ')'];
    end
    
    if permite_pico
        inputs_valores{end+1} = Mp;        inputs_nome{end+1} = 'Mp';
    end
    inputs_valores{end+1} = nu;        inputs_nome{end+1} = 'nu_real';
    inputs_valores{end+1} = zeta;      inputs_nome{end+1} = 'zeta_real';
    N_total_vars = length(inputs_valores);
    
    %% --- EXECUÇÃO DOS FITS ---
    [best_R2_nu_ind, v1_nu_ind, v2_nu_ind, pts_nu_ind] = run_search_robust(inputs_valores, inputs_nome, nu, idx, N_total_vars, 'nu', true);
    [best_R2_nu_dep, v1_nu_dep, v2_nu_dep, pts_nu_dep] = run_search_robust(inputs_valores, inputs_nome, nu, idx, N_total_vars, 'nu', false);
    
    [best_R2_z_ind, v1_z_ind, v2_z_ind, pts_z_ind]   = run_search_robust(inputs_valores, inputs_nome, zeta, idx, N_total_vars, 'zeta', true);
    [best_R2_z_dep, v1_z_dep, v2_z_dep, pts_z_dep]   = run_search_robust(inputs_valores, inputs_nome, zeta, idx, N_total_vars, 'zeta', false);
    
    %% --- IMPRESSÃO DOS RESULTADOS ---
    fprintf('\n  [ IDENTIFICAÇÃO DE NU ]\n');
    fprintf('    -> Sem dependência mútua:\n');
    fprintf('       R² = %.5f  |  Amostras Usadas: %d  |  Inputs: [%s] e [%s]\n', best_R2_nu_ind, pts_nu_ind, v1_nu_ind, v2_nu_ind);
    fprintf('    -> Com dependência mútua (Permitindo Zeta Real):\n');
    fprintf('       R² = %.5f  |  Amostras Usadas: %d  |  Inputs: [%s] e [%s]\n', best_R2_nu_dep, pts_nu_dep, v1_nu_dep, v2_nu_dep);
    
    fprintf('\n  [ IDENTIFICAÇÃO DE ZETA ]\n');
    fprintf('    -> Sem dependência mútua:\n');
    fprintf('       R² = %.5f  |  Amostras Usadas: %d  |  Inputs: [%s] e [%s]\n', best_R2_z_ind, pts_z_ind, v1_z_ind, v2_z_ind);
    fprintf('    -> Com dependência mútua (Permitindo Nu Real):\n');
    fprintf('       R² = %.5f  |  Amostras Usadas: %d  |  Inputs: [%s] e [%s]\n', best_R2_z_dep, pts_z_dep, v1_z_dep, v2_z_dep);
    fprintf('------------------------------------------------------------------------\n\n');
end

warning('on', 'curvefit:fit:equationBadlyConditioned');
warning('on', 'curvefit:fit:perfectFit');

%% =========================================================================
%   FUNÇÃO DE PROCURA COM FILTRAGEM LOCAL DE NAN/INF
%% =========================================================================
function [best_R2, best_v1, best_v2, samples_used] = run_search_robust(inputs_vals, inputs_names, Y_global, idx, N_vars, target_type, strict_independent)
    best_R2 = -Inf; best_v1 = 'N/A'; best_v2 = 'N/A'; samples_used = 0;
    
    opts = fitoptions('poly44');
    opts.Normalize = 'on'; 
    
    for i = 1:N_vars
        for j = (i+1):N_vars
            
            % Restrições de Independência Mútua
            if strict_independent
                if any(strcmp(inputs_names{i}, {'nu_real','zeta_real'})) || any(strcmp(inputs_names{j}, {'nu_real','zeta_real'})), continue; end
            end
            if strcmp(target_type, 'nu') && (strcmp(inputs_names{i}, 'nu_real') || strcmp(inputs_names{j}, 'nu_real')), continue; end
            if strcmp(target_type, 'zeta') && (strcmp(inputs_names{i}, 'zeta_real') || strcmp(inputs_names{j}, 'zeta_real')), continue; end
            
            % Extração local baseada no cenário
            v1 = inputs_vals{i}(idx);
            v2 = inputs_vals{j}(idx);
            Y  = Y_global(idx);
            
            % FILTRAGEM PAR A PAR: Remove NaNs e Infs gerados especificamente por estas variáveis
            valid_pts = ~isnan(v1) & ~isinf(v1) & ~isnan(v2) & ~isinf(v2) & ~isnan(Y) & ~isinf(Y);
            N_validos = sum(valid_pts);
            
            % Se o par descartar dados em excesso, ignora-o para proteger o range
            if N_validos < 100, continue; end
            
            try
                [~, gof] = fit([v1(valid_pts), v2(valid_pts)], Y(valid_pts), 'poly44', opts);
                if gof.rsquare > best_R2 && gof.rsquare < 0.9999
                    best_R2 = gof.rsquare;
                    best_v1 = inputs_names{i};
                    best_v2 = inputs_names{j};
                    samples_used = N_validos;
                end
            catch
                continue;
            end
        end
    end
end