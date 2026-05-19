

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


idx = nu>0.6 & zeta < 2;

tau1 = (t05./t02);
tau2 = t08./t02;
tau3 = t02./t07;
tau4 = t01./t02;
tau5 = (t08-t05)./(t05-t02);
tau6 = tp./t01;


% nu
X_nu = [log(tau3(idx)), (tau2(idx))];
Y_nu = nu(idx);
[fit_nu, gof_nu] = fit(X_nu, Y_nu, 'poly33');
fprintf('R-squared para Nu0: %.4f\n', gof_nu.rsquare);
figure, plot3(tau6(idx), Mp(idx), nu(idx), '.'), grid on;


