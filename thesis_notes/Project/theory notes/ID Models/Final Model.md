# Id Model for $(\nu, \nu+1)$

#### The system
$$
\begin{equation}
	G(s) = \frac{1}{1 + 2\zeta \left( \frac{s}{\omega_n} \right)^\nu + \left( \frac{s}{\omega_n} \right)^{\nu+1}}
\tag{4}
\end{equation}

$$

## Extracted Points
---

> [!warning] Key changes
> The extracted points are now interpolated to ensure higher precision

![[Pasted image 20260519142706.png|459]]

```

```
## Identification Logic
---

> [!info] Note
> Identification for $\nu \leq 0.6$ is disregarded because most systems have a really slow response

### Identification of $\zeta$

#### If there is overshoot:

$\tau_1 = \frac{t_{0,7}}{t_p}$
$\tau_2 = \frac{t_{0,8} - t_{0,5}}{t_{0,5} - t_{0,2}}$


$$\begin{aligned} \zeta_{p}(\ln\tau_1, \tau_2) = & \, p_{00} + p_{10}\ln\tau_1 + p_{01}\tau_2 + p_{20}(\ln\tau_1)^2 + p_{11}\ln\tau_1\tau_2 + p_{02}\tau_2^2 \\ & + p_{30}(\ln\tau_1)^3 + p_{21}(\ln\tau_1)^2\tau_2 + p_{12}\ln\tau_1\tau_2^2 + p_{03}\tau_2^3 \\ & + p_{40}(\ln\tau_1)^4 + p_{31}(\ln\tau_1)^3\tau_2 + p_{22}(\ln\tau_1)^2\tau_2^2 + p_{13}\ln\tau_1\tau_2^3 + p_{04}\tau_2^4 \end{aligned}$$

```
R-squared para Zeta_p: 0.8780
```

#### If there is no overshoot:

$\tau_1 = \frac{t_{0,1}}{t_{0,5}}$
$\tau_1 = \frac{t_{0,8}}{t_{0,2}}$

$$\begin{aligned} \zeta_{\text{n}}(\ln\tau_3, \tau_4) = & \, q_{00} + q_{10}\ln\tau_3 + q_{01}\tau_4 + q_{20}(\ln\tau_3)^2 + q_{11}\ln\tau_3\tau_4 + q_{02}\tau_4^2 \\ & + q_{30}(\ln\tau_3)^3 + q_{21}(\ln\tau_3)^2\tau_4 + q_{12}\ln\tau_3\tau_4^2 + q_{03}\tau_4^3 \\ & + q_{40}(\ln\tau_3)^4 + q_{31}(\ln\tau_3)^3\tau_4 + q_{22}(\ln\tau_3)^2\tau_4^2 + q_{13}\ln\tau_3\tau_4^3 + q_{04}\tau_4^4 \end{aligned}$$

```
R-squared para Zeta_n: 0.9621
```

### Identification of $\nu$
#### If $\zeta \geq 2$:

$\tau_5 = \frac{t_{0,5}}{t_{0,9}}$

$$\nu_1(\tau_5, \tau_3) = r_{00} + r_{10}\tau_5 + r_{01}\tau_3 + r_{20}\tau_5^2 + r_{11}\tau_5\tau_3 + r_{02}\tau_3^2$$
```
R-squared para nu_1: 0.9915
```
#### If $\zeta < 2$:
$$\begin{aligned} \nu_2(\tau_5, \zeta) = & \, s_{00} + s_{10}\tau_5 + s_{01}\zeta + s_{20}\tau_5^2 + s_{11}\tau_5\zeta + s_{02}\zeta^2 \\ & + s_{30}\tau_5^3 + s_{21}\tau_5^2\zeta + s_{12}\tau_5\zeta^2 \end{aligned}$$

```
R-squared para nu_2: 0.9972
```

## Coefficient Values
---

For the $\zeta$ models:

| Coefficient |   Estimated Value   | Coefficient | Estimated Value |
| :---------: | :-----------------: | :---------: | :-------------: |
|   **p00**   |        -742         |   **q00**   |     -11.96      |
|   **p10**   |        -1661        |   **q10**   |     -42.86      |
|   **p01**   |        1144         |   **q01**   |      20.31      |
|   **p20**   | $1.06 \times 10^4$  |   **q20**   |     -16.48      |
|   **p11**   | $2.043 \times 10^4$ |   **q11**   |      53.79      |
|   **p02**   |        6490         |   **q02**   |     -11.66      |
|   **p30**   | $2.633 \times 10^4$ |   **q30**   |      22.84      |
|   **p21**   | $4.12 \times 10^4$  |   **q21**   |      16.32      |
|   **p12**   | $1.321 \times 10^4$ |   **q12**   |     -17.58      |
|   **p03**   |       -637.6        |   **q03**   |      2.585      |
|   **p40**   | $1.423 \times 10^4$ |   **q40**   |      17.65      |
|   **p31**   | $1.925 \times 10^4$ |   **q31**   |     -3.702      |
|   **p22**   |        2890         |   **q22**   |     -3.421      |
|   **p13**   |        -2873        |   **q13**   |      1.942      |
|   **p04**   |       -457.1        |   **q04**   |     -0.1983     |

For the $\nu$ models:

| Coefficient | Estimated Value | Coefficient | Estimated Value |
| :---------: | :-------------: | :---------: | :-------------: |
|   **r00**   |     0.9343      |   **s00**   |     0.3404      |
|   **r10**   |      1.273      |   **s10**   |      1.623      |
|   **r01**   |     -3.411      |   **s01**   |     0.2744      |
|   **r20**   |     0.3277      |   **s20**   |     -7.181      |
|   **r11**   |      1.806      |   **s11**   |      1.577      |
|   **r02**   |      4.141      |   **s02**   |     -0.1397     |
|             |                 |   **s30**   |      8.634      |
|             |                 |   **s21**   |     -0.9272     |
|             |                 |   **s12**   |     -0.1703     |


## Error Metrics
---

| Metric               | Mean Value | Max Value |
| :------------------- | :--------: | :-------: |
| **RMS **             |   0.0459   |  0.5733   |
| **Error in $\nu$**   |   0.0460   |  0.6886   |
| **Error in $\zeta$** |   0.2185   |  1.3183   |

### RMS

![[Pasted image 20260519140914.png|344]]


### Error in $\zeta$

![[Pasted image 20260519140953.png|341]]

### Error in $\nu$

![[Pasted image 20260519141028.png|344]]