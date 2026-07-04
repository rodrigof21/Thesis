% Data for First Test Simulink

% integer values
xi = 0.3;
wn = 1;

% fractional values
nu = 1.2;
zeta = 2;
wn_f = 1;

coef_1 = 1 / (wn_f^(nu+1));
ord_1 = nu + 1;

coef_2 = (2*zeta) / (wn_f^nu);
ord_2 = nu;
str_polos = sprintf('%g*s^%g + %g*s^%g + 1', coef_1, ord_1, coef_2, ord_2);

display(str_polos)

