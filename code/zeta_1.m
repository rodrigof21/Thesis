

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


idx = nu > 0.3;

tau = t08./t02;
tau2 = t05./t02;


% zeta
X_zeta = [log(tau(idx)), (tau2(idx))];
Y_zeta = (zeta(idx));
[fit_zeta, gof_zeta] = fit(X_zeta, Y_zeta, 'poly42');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);


%figure, plot3(tau(idx), Mp(idx), nu(idx), '.'), grid on;