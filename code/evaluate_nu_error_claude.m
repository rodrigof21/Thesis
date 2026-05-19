%% R² e erros reais de nu e zeta separadamente
%X = [log(tau), log(tau2)];   % ou os rácios que estás a usar agora

[fit_nu,   gof_nu]   = fit(X_nu, nu,   'poly33');
[fit_zeta, gof_zeta] = fit(X_zeta, zeta, 'poly44');

nu_pred   = feval(fit_nu,   X(:,1), X(:,2));
zeta_pred = feval(fit_zeta, X(:,1), X(:,2));

fprintf('R² nu:       %.4f\n', gof_nu.rsquare);
fprintf('R² zeta:     %.4f\n', gof_zeta.rsquare);
fprintf('RMS nu:      %.4f\n', rms(nu   - nu_pred));
fprintf('RMS zeta:    %.4f\n', rms(zeta - zeta_pred));
fprintf('Max err nu:  %.4f\n', max(abs(nu   - nu_pred)));
fprintf('Max err zeta:%.4f\n', max(abs(zeta - zeta_pred)));

%% Onde falha nu — scatter real vs predito
figure;
subplot(1,2,1);
scatter(nu, nu_pred, 20, zeta, 'filled');
hold on; plot([min(nu) max(nu)], [min(nu) max(nu)], 'r--', 'LineWidth', 2);
colorbar; xlabel('nu real'); ylabel('nu predito');
title(sprintf('nu — R²=%.4f', gof_nu.rsquare)); grid on;

subplot(1,2,2);
scatter(nu, nu - nu_pred, 20, zeta, 'filled');
colorbar; xlabel('nu real'); ylabel('erro');
title('Erro de nu — cor = zeta'); grid on;
yline(0, 'r--');