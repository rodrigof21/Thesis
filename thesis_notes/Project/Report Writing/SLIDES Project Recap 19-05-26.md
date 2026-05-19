

**ID of the non-commensurate fractional order system of the second species $(\nu, \nu+1)$ from its unit step time response**
Rodrigo Fonseca - Project Recap

---
### The system

$$
\begin{equation}
	G(s) = \frac{1}{1 + 2\zeta \left( \frac{s}{\omega_n} \right)^\nu + \left( \frac{s}{\omega_n} \right)^{\nu+1}}
\tag{4}
\end{equation}

$$

---

#### The work of Hmed et al.

Stability Regions and Ressonance. My works was based on the arcticle by Hmed et al. where the stability and ressonance regions for my system were deeply studied.

![[Pasted image 20260212121230.png|357]]

---

**The Effect of $\omega_n$**


![[time_scaling_wn.png|364]]

It was proved that the natural frequency works as a scale factor in time (inversely proportional to $\omega_n$).

---
#### Extracted points

![[curve_with_points.png|355]]

Time ratios:
- $\tau_1 = \frac{t_{0,8}}{t_{0,2}}$
- $\tau_2 = \frac{t_{0,5}}{t_{0,2}}$

---
#### Identification Logic

For $\nu > 0.6$ and $\zeta \geq 2$:
- $\nu = f(\ln \tau_1, \ln \tau_2) \rightarrow \texttt{poly33}$
- $\zeta = f(\ln\tau_2, \nu) \rightarrow \texttt{poly43}$

For $\nu > 0.6$ and $\zeta < 2$:
- $\zeta = f(, )$
- $\zeta = f(,)$

For $\nu < 0.46 identification is not possible


---
#### ID of the Natural Frequency

$\omega_n \approx \frac{a}{t}$
$a = t\cdot\omega_n \equiv a \approx mean(t\cdot\omega_n)$

$a = f(\nu, \zeta) \rightarrow \texttt{polyXX}$

---


---

