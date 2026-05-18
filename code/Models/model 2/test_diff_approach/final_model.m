% filteredPoints (better alternative to results)
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

% points data
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);
t07  = results(:, 6);
Mp   = results(:, 7);
tp   = results(:, 8);
t01  = results(:, 9);
t09 = results(:, 10);



% Zeta quando há pico

idx_pico = nu > 0.6 & Mp > 10e-5;
tau1 = (t07./tp);
tau2 = (t08-t05)./(t05-t02);

X_zeta_p = [log(tau1(idx_pico)),(tau2(idx_pico))];
[fit_zeta_p, gof_zeta_p] = fit(X_zeta_p, zeta(idx_pico), 'poly44');
fprintf('R-squared para Zeta_p: %.4f\n', gof_zeta_p.rsquare);

figure('Visible','off'),
plot(fit_zeta_p, X_zeta_p, zeta(idx_pico));

% Zeta sem pico

idx_npico = nu > 0.6 & Mp <= 10e-5;
tau3 = (t01./t05);
tau4 = t08./t02;

X_zeta_n = [log(tau3(idx_npico)),(tau4(idx_npico))];
[fit_zeta_n, gof_zeta_n] = fit(X_zeta_n, zeta(idx_npico), 'poly44');
fprintf('R-squared para Zeta_n: %.4f\n', gof_zeta_n.rsquare);



% nu para zeta => 2

idx1 = nu > 0.6 & zeta >=2;
tau5 = t05./t09;

X_nu_1 = [tau5(idx1), tau3(idx1)];
[fit_nu_1, gof_nu_1] = fit(X_nu_1, nu(idx1), 'poly44');
fprintf('R-squared para nu_1: %.4f\n', gof_nu_1.rsquare);



% nu para zeta < 2

idx2 = nu > 0.6 & zeta < 2;

X_nu_2 = [tau5(idx2), zeta(idx2)];
[fit_nu_2, gof_nu_2] = fit(X_nu_2, nu(idx2), 'poly44');
fprintf('R-squared para nu_2: %.4f\n', gof_nu_2.rsquare);


idModel_final = struct();
idModel_final.peak = fit_zeta_p;
idModel_final.npeak = fit_zeta_n;
idModel_final.nu_1 = fit_nu_1;
idModel_final.nu_2 = fit_nu_2;

% --- save ---
savePath = 'C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final';

if ~exist(fileparts(savePath), 'dir')
    mkdir(fileparts(savePath));
end

save(savePath, 'idModel_final');
fprintf('Modelo idModel_final gravado com sucesso em: %s\n', savePath);