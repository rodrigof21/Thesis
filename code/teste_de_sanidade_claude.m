load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')

idx = nu >= 0.6 & Mp > 0;

vars  = {log(tau(idx)), log(tau2(idx)), log(tau3(idx)), log(tau4(idx)), Mp(idx)};
nomes = {'log(tau)', 'log(tau2)', 'log(tau3)', 'log(tau4)', 'Mp'};
n = length(vars);

fprintf('%-65s  R²_nu   R²_zeta\n', 'Quádrupla');
fprintf('%s\n', repmat('-',1,85));
for i = 1:n
    for j = i+1:n
        for k = j+1:n
            for l = k+1:n
                X = [vars{i}, vars{j}, vars{k}, vars{l}];
                try
                    PHI = [ones(size(X,1),1), X, X.^2, ...
                           X(:,1).*X(:,2), X(:,1).*X(:,3), X(:,1).*X(:,4), ...
                           X(:,2).*X(:,3), X(:,2).*X(:,4), X(:,3).*X(:,4)];

                    theta_nu   = PHI \ nu(idx);
                    theta_zeta = PHI \ zeta(idx);

                    nu_pred   = PHI * theta_nu;
                    zeta_pred = PHI * theta_zeta;

                    R2_nu   = 1 - sum((nu(idx)   - nu_pred).^2)   / ...
                                  sum((nu(idx)   - mean(nu(idx))).^2);
                    R2_zeta = 1 - sum((zeta(idx) - zeta_pred).^2) / ...
                                  sum((zeta(idx) - mean(zeta(idx))).^2);

                    nome = [nomes{i} ' + ' nomes{j} ' + ' nomes{k} ' + ' nomes{l}];
                    fprintf('%-65s  %.4f  %.4f\n', nome, R2_nu, R2_zeta);
                catch
                    fprintf('ERRO\n');
                end
            end
        end
    end
end