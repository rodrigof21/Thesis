

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


idx = nu > 0.6 & Mp > 0.00001;

tau1 = (t05./t02);
tau2 = t08./t02;
tau3 = t02./t07;
tau4 = t01./t02;
tau5 = (t08-t05)./(t05-t02);
tau6 = tp./t01;

tau1 = tau1(idx);
tau2 = tau2(idx);
tau3 = tau3(idx);
tau4 = tau4(idx);
tau5 = tau5(idx);
tau6 = tau6(idx);
Mp = Mp(idx);
zeta = zeta(idx);

% zeta
X_zeta = [tau5, Mp];
Y_zeta = (zeta);
[fit_zeta, gof_zeta] = fit(X_zeta, Y_zeta, 'poly44');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);


%figure, plot3(tau(idx), Mp(idx), zeta(idx), '.'), grid on;