### 1st Option

```
tau = t08./t02;
tau2 = tp./t02;

halfpoint = 1.0;
idx0 = nu < halfpoint;
idx1 = nu >= halfpoint;

Y_nu0 = nu(idx0);
Y_nu1 = nu(idx1);

% nu0
X_nu0 = [log(tau(idx0)), log(tau2(idx0))];
[fit_nu0, gof_nu0] = fit(X_nu0, Y_nu0, 'poly33');
fprintf('R-squared para Nu0: %.4f\n', gof_nu0.rsquare);

% nu1
X_nu1 = [log(tau(idx1)), log(tau2(idx1))];
[fit_nu1, gof_nu1] = fit(X_nu1, Y_nu1, 'poly33');
fprintf('R-squared para Nu1: %.4f\n', gof_nu1.rsquare);

% zeta
X_zeta = [log(tau), nu];
[fit_zeta, gof_zeta] = fit(X_zeta, zeta, 'poly33');
fprintf('R-squared para Zeta: %.4f\n', gof_zeta.rsquare);
```

Results:
```
R-squared para Nu0: 0.9820
R-squared para Nu1: 0.9145
R-squared para Zeta: 0.9555
```

---

### 2nd Option

```
tau = t08./t02;
tau2 = Mp;
```

Results:
```
R-squared para Nu0: 0.9384
R-squared para Nu1: 0.9243
R-squared para Zeta: 0.9555
```

