load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PSO_data_withTf.mat")

nu   = PSO_data(:, 1);
zeta = PSO_data(:, 2);
Kp   = PSO_data(:, 3);
Ki   = PSO_data(:, 4);
Kd   = PSO_data(:, 5);
Tf   = PSO_data(:, 6);

% Kp Model
X = [nu, zeta];
[fit_kp, gof_kp] = fit(X, Kp, 'Poly44');
fprintf('Kp R^2 = %.4f\n', gof_kp.rsquare)
figure, plot(fit_kp, X, Kp)
title('Kp')

% Ki Model
[fit_ki, gof_ki] = fit(X, Ki, 'Poly44');
fprintf('Ki R^2 = %.4f\n', gof_ki.rsquare)
figure, plot(fit_ki, X, Ki)
title('Ki')

% Kd Model
[fit_kd, gof_kd] = fit(X, Kd, 'Poly44');
fprintf('Kd R^2 = %.4f\n', gof_kd.rsquare)
figure, plot(fit_kd, X, Kd)
title('Kd')

% Tf Model
[fit_tf, gof_tf] = fit(X, Tf, 'Poly44');
fprintf('Tf R^2 = %.4f\n', gof_tf.rsquare)
figure, plot(fit_tf, X, Tf)
title('Tf')