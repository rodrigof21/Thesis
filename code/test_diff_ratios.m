%% Todos os tempos disponíveis
tempos = [t02, t05, t08, t09, t95, t99];
nomes_t = {'t02','t05','t08','t09','t95','t99'};
n = length(nomes_t);

%% Gera todas as combinações de rácios t_i / t_j  (i < j)
racios = [];
nomes_r = {};

for i = 1:n
    for j = 1:n
        if i ~= j
            r = tempos(:,i) ./ tempos(:,j);
            % filtra rácios inválidos (inf, nan, negativos)
            if all(isfinite(r)) && all(r > 0)
                racios   = [racios, r];
                nomes_r{end+1} = sprintf('%s/%s', nomes_t{i}, nomes_t{j});
            end
        end
    end
end

fprintf('Total de rácios gerados: %d\n', size(racios, 2));

%% Correlação de cada rácio com nu e zeta
X = log(racios);   % log lineariza
corr_nu   = corr(X, nu);
corr_zeta = corr(X, zeta);

%% Ordena por correlação com zeta (o problema difícil)
[~, idx_z] = sort(abs(corr_zeta), 'descend');

fprintf('\n%-20s  %8s  %8s\n', 'Rácio', 'corr(nu)', 'corr(zeta)');
fprintf('%s\n', repmat('-', 1, 42));
for k = 1:length(idx_z)
    fprintf('%-20s  %+8.4f  %+8.4f\n', ...
        nomes_r{idx_z(k)}, corr_nu(idx_z(k)), corr_zeta(idx_z(k)));
end

%% Matriz de correlação visual
figure('Position', [100 100 1000 800]);
labels = [nomes_r, {'\nu', '\zeta'}];
C = corr([X, nu, zeta]);
imagesc(C);
colorbar; colormap('cool');
clim([-1 1]);
xticks(1:length(labels)); xticklabels(labels); xtickangle(45);
yticks(1:length(labels)); yticklabels(labels);
title('Matriz de correlação — log(rácios), \nu, \zeta');

% linhas a separar os rácios de nu e zeta
hold on;
nr = length(nomes_r);
plot([nr+0.5 nr+0.5], [0.5 nr+2.5], 'k-', 'LineWidth', 2);
plot([0.5 nr+2.5], [nr+0.5 nr+0.5], 'k-', 'LineWidth', 2);

%% Top 5 rácios para nu e zeta separadamente
fprintf('\n--- TOP 5 para NU ---\n');
[~, idx_n] = sort(abs(corr_nu), 'descend');
for k = 1:5
    fprintf('%d. %-20s  corr(nu)=%.4f  corr(zeta)=%.4f\n', ...
        k, nomes_r{idx_n(k)}, corr_nu(idx_n(k)), corr_zeta(idx_n(k)));
end

fprintf('\n--- TOP 5 para ZETA ---\n');
for k = 1:5
    fprintf('%d. %-20s  corr(nu)=%.4f  corr(zeta)=%.4f\n', ...
        k, nomes_r{idx_z(k)}, corr_nu(idx_z(k)), corr_zeta(idx_z(k)));
end

%% Par óptimo — máxima correlação cruzada mínima
% Quer: |corr(r1,nu)| alto, |corr(r1,zeta)| baixo  → r1 identifica nu
%       |corr(r2,zeta)| alto, |corr(r2,nu)| baixo  → r2 identifica zeta
score_nu   = abs(corr_nu)   - abs(corr_zeta);   % >0 = bom para nu
score_zeta = abs(corr_zeta) - abs(corr_nu);      % >0 = bom para zeta

[~, best_nu]   = max(score_nu);
[~, best_zeta] = max(score_zeta);

fprintf('\n--- PAR ÓPTIMO ---\n');
fprintf('Para NU:   %s  (corr_nu=%.4f, corr_zeta=%.4f)\n', ...
    nomes_r{best_nu},   corr_nu(best_nu),   corr_zeta(best_nu));
fprintf('Para ZETA: %s  (corr_nu=%.4f, corr_zeta=%.4f)\n', ...
    nomes_r{best_zeta}, corr_nu(best_zeta), corr_zeta(best_zeta));
