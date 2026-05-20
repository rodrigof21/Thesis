

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


![[Pasted image 20260212121230.png|357]]

Stability Regions and Ressonance

---

**The Effect of $\omega_n$**


![[time_scaling_wn.png|364]]

It was proved that the natural frequency works as a scale factor in time (inversely proportional to $\omega_n$).

---
#### Extracted points

![[Pasted image 20260519142706.png|514]]

Time rations will be used to ensure adimensionality.

---

**Identification of $\zeta$**
#### If there is overshoot:

$\tau_1 = \frac{t_{0,7}}{t_p}$
$\tau_2 = \frac{t_{0,8} - t_{0,5}}{t_{0,5} - t_{0,2}}$


$$\begin{aligned} \zeta_{p}(\ln\tau_1, \tau_2) = & \, p_{00} + p_{10}\ln\tau_1 + p_{01}\tau_2 + p_{20}(\ln\tau_1)^2 \\ & +  p_{11}\ln\tau_1\tau_2 + p_{02}\tau_2^2  + p_{30}(\ln\tau_1)^3 \\ & +  p_{21}(\ln\tau_1)^2\tau_2 + p_{12}\ln\tau_1\tau_2^2 + p_{03}\tau_2^3 \\ & + p_{40}(\ln\tau_1)^4 + p_{31}(\ln\tau_1)^3\tau_2 \\ & +  p_{22}(\ln\tau_1)^2\tau_2^2 +  p_{13}\ln\tau_1\tau_2^3 + p_{04}\tau_2^4 \end{aligned}$$


---
#### If there is no overshoot:

$\tau_3 = \frac{t_{0,1}}{t_{0,5}}$
$\tau_4 = \frac{t_{0,8}}{t_{0,2}}$

$$\begin{aligned}  \zeta_{\text{n}}(\ln\tau_3, \tau_4) = & \, q_{00} + q_{10}\ln\tau_3 + q_{01}\tau_4 + q_{20}(\ln\tau_3)^2 \\ & + q_{11}\ln\tau_3\tau_4 + q_{02}\tau_4^2 + q_{30}(\ln\tau_3)^3 \\ & + q_{21}(\ln\tau_3)^2\tau_4 + q_{12}\ln\tau_3\tau_4^2 + q_{03}\tau_4^3 \\ & + q_{40}(\ln\tau_3)^4 + q_{31}(\ln\tau_3)^3\tau_4 + q_{22}(\ln\tau_3)^2\tau_4^2 \\ &+ q_{13}\ln\tau_3\tau_4^3 + q_{04}\tau_4^4 \end{aligned}$$

---
**Identification of $\nu$**
**If $\zeta \geq 2$:**

$\tau_5 = \frac{t_{0,5}}{t_{0,9}}$

$$\nu_1(\tau_5, \tau_3) = r_{00} + r_{10}\tau_5 + r_{01}\tau_3 + r_{20}\tau_5^2 + r_{11}\tau_5\tau_3 + r_{02}\tau_3^2$$


---
**If $\zeta < 2$:**
$$\begin{aligned} \nu_2(\tau_5, \zeta) = & \, s_{00} + s_{10}\tau_5 + s_{01}\zeta + s_{20}\tau_5^2 + s_{11}\tau_5\zeta + s_{02}\zeta^2 \\ & + s_{30}\tau_5^3 + s_{21}\tau_5^2\zeta + s_{12}\tau_5\zeta^2 \end{aligned}$$

---
#### Error Metrics For the models

| Metric               | Mean Value | Max Value |
| :------------------- | :--------: | :-------: |
| **RMS **             |   0.0459   |  0.5733   |
| **Error in $\nu$**   |   0.0460   |  0.6886   |
| **Error in $\zeta$** |   0.2185   |  1.3183   |
|                      |            |           |

---

![[Pasted image 20260519140914.png|227]] ![[Pasted image 20260519140953.png|219]] ![[Pasted image 20260519141028.png|220]]


**RMS values and Errors in $\zeta$ and $\nu$**

---
#### ID of the Natural Frequency

$\omega_n \approx \frac{a}{t_k}$
$a = t_k \cdot\omega_n \equiv a \approx mean(t_k\cdot\omega_n)$

![[Pasted image 20260228132727.png|348]]

$a = f(\nu, \zeta) \rightarrow \texttt{polyXX}$

---

**Another Option** would be

$$\omega_n = \frac{t_{k_{\omega_n = 1}}}{t_k}$$

Because of the time-scaling properties of $\omega_n$

---

#### Future Work

- Noise Robustness
- PID design

---

**ID of the non-commensurate fractional order system of the second species $(\nu, \nu+1)$ from its unit step time response**
Rodrigo Fonseca - Project Recap

