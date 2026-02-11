### Constants

**Natural frequency** (omega): $\omega_n$
**Damping Coefficient** (zeta): $\zeta$
**Fraction order** (nu) : $\nu$


### System type numbering


#### System (4)
$$
\begin{equation}
	G(s) = \frac{1}{1 + 2\zeta \left( \frac{s}{\omega_n} \right)^\nu + \left( \frac{s}{\omega_n} \right)^{\nu+1}}
\tag{4}
\end{equation}

$$
Matlab Code:

```
G = fotf([1/(wn^(nu+1)), (2*zeta)/(wn^nu), 1], [nu+1, nu, 0], 1, 0);
G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
```



#### System (99)
$$
G(s) = \frac{\omega_n^2}{s^{\nu+1} + 2\zeta\omega_n s^\nu + \omega_n^2}
\tag{99}
$$

Matlab Code:

```
G = foft()
G = @(s) wn.^2 ./ (s.^(nu+1) + 2.*zeta.*wn.*s.^nu + wn.^2);
```

