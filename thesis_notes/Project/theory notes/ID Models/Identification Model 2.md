
>[!warning]
>The parameters were changed to $log(\tau)$ and $log(t_{05})$ both for $\nu$ and $\zeta$ models

[[idModel_2.m]]

* **Time Ratio ($\tau$):** $\tau = \frac{t_{0.8}}{t_{0.2}}$
* 
### Equation (poly22) 

$$\nu(\tau, t_{0.5}) = p_{00} + p_{10}\tau + p_{01}t_{0.5} + p_{20}\tau^2 + p_{11}\tau t_{0.5} + p_{02}t_{0.5}^2$$

$$\nu(\tau, t_{0.5}) = p_{00} + p_{10}\ln \tau + p_{01}\ln t_{0.5} + p_{20}(\ln \tau)^2 + p_{11}(\ln \tau)(\ln t_{0.5}) + p_{02}(\ln t_{0.5})^2$$

### Equation (poly22) 

$$\zeta(t_{0.5}, \nu) = q_{00} + q_{10}t_{0.5} + q_{01}\nu + q_{20}t_{0.5}^2 + q_{11}t_{0.5}\nu + q_{02}\nu^2$$

$$\zeta(t_{0.5}, \nu) = q_{00} + q_{10}\ln t_{0.5} + q_{01}\nu + q_{20}(\ln t_{0.5})^2 + q_{11}(\ln t_{0.5})\nu + q_{02}\nu^2$$

### $\nu$ with poly33 (better)

$$nu(\tau, t_{0.5}) =p_{00} + p_{10}\ln(\tau) + p_{01}\ln(t_{0.5}) + p_{20}\ln(\tau)^2 + p_{11}\ln(\tau)\ln(t_{0.5}) + p_{02}\ln(t_{0.5})^2 + p_{30}\ln(\tau)^3 + p_{21}\ln(\tau)^2\ln(t_{0.5}) + p_{12}\ln(\tau)\ln(t_{0.5})^2 + p_{03}\ln(t_{0.5})^3$$

### With the coefficients

>[!info]
>The results must be updated
>Run [[idModel_2.m]]


$$\nu(\tau, t_{0.5}) = 1.6295 + -1.3239\cdot \tau + 1.7639\cdot t_{0.5} + 0.1878\cdot \tau^2 + -0.0748\cdot \tau\cdot t_{0.5} + -0.2966\cdot t_{0.5}^2$$
$$\zeta(t_{0.5}, \nu) = -0.7427 + 1.2557\cdot t_{0.5} + -0.8545\cdot \nu + -0.4000\cdot t_{0.5}^2 + 1.3128\cdot t_{0.5}\cdot \nu + -0.5995\cdot \nu^2$$


#### Results
---

![[Pasted image 20260317062140.png]]

