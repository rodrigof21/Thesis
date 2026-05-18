

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
t95 = results(:, 11);
t99 = results(:, 12);


idx = nu > 0.6 & Mp > 0;

tau1 = (t05./t02);
tau2 = t08./t02;
tau3 = t02./t07;
tau4 = t01./t02;
tau5 = (t08-t05)./(t05-t02);
tau6 = tp./t01;


% zeta
X_zeta = [log(tau2(idx)),log(Mp(idx))];
Y_zeta = (zeta(idx));
[fit_zeta, gof_zeta] = fit(X_zeta, Y_zeta, 'poly44');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);


%figure, plot3(tau(idx), Mp(idx), zeta(idx), '.'), grid on;

