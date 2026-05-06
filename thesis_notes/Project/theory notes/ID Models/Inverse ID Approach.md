# Identification Strategy: Analytical Inversion of the Direct Model

This document details the methodology for overcoming the "verticality" problem when identifying the parameter $\nu$ in second-species fractional-order systems.

---

## 1. The Direct Model (Response Surface)

Instead of attempting to fit $\nu = f(\tau_1, \tau_2)$, which leads to numerical instability due to infinite gradients (vertical branches), we utilize a **direct** model where the time ratio is the output. This model typically achieves an $R^2 \approx 0.999$.

The $poly22$ polynomial structure for $\tau_2$ as a function of $\tau_1$ and $\nu$ is:

$$\tau_2 = p_{00} + p_{10}\tau_1 + p_{01}\nu + p_{20}\tau_1^2 + p_{11}\tau_1\nu + p_{02}\nu^2$$

> [!NOTE] Variable Definitions
> - $\tau_1, \tau_2$: Adimensional time ratios extracted from the curve (e.g., $t_{0.8}/t_{0.2}$ or $t_{0.5}/t_{0.2}$).
> - $\nu$: Fractional order of the system (the parameter to be identified).

---

## 2. Analytical Inversion Derivation

To identify $\nu$ from measured values of $\tau_1$ and $\tau_2$, we restructure the above equation into a standard quadratic form:
$$A\nu^2 + B\nu + C = 0$$

### Isolating the Coefficients
Grouping the terms of the original polynomial as a function of $\nu$:

1. **Quadratic Term ($A$):**
   $$A = p_{02}$$

2. **Linear Term ($B$):** 
   Depends on the measured value of $\tau_1$.
   $$B(\tau_1) = p_{01} + p_{11}\tau_1$$

3. **Independent Term ($C$):** 
   Depends on both measured ratios ($\tau_1$ and $\tau_2$).
   $$C(\tau_1, \tau_2) = (p_{00} + p_{10}\tau_1 + p_{20}\tau_1^2) - \tau_2$$

---

## 3. Identification Solution

The identified fractional order ($\hat{\nu}$) is obtained via the quadratic formula:

$$\hat{\nu} = \frac{-B(\tau_1) \pm \sqrt{B(\tau_1)^2 - 4AC(\tau_1, \tau_2)}}{2A}$$

### Selection Criteria
As this is a quadratic equation, two mathematical solutions will exist. The correct solution for the thesis must satisfy:
1. **Physical Domain:** $0.1 \le \nu \le 2.0$.
2. **Continuity:** The root that maintains consistency with the expected system behavior (usually the root resulting from the specific sign of the discriminant that falls within the stable range).

---

## 4. Advantages of this Approach

- **Singularity Bypass:** Resolves the issue of "vertical branches" where the gradient $\nabla_{\tau} \nu$ tends toward infinity.
- **Numerical Robustness:** Identification accuracy now depends solely on the precision of the direct model fit ($R^2 = 0.999$), eliminating artifacts from unstable rational model fitting.
- **Computational Efficiency:** Identification is performed through direct calculation (instantaneous), without the need for iterative real-time optimization algorithms.



## 5. Numerical Implementation and Case Study

Based on the regression analysis of the second-species system data, the following numerical coefficients were identified to define the relationship between the time ratios and the fractional order.

### 5.1 The Calibrated Direct Model
The direct mapping for $\tau_2$ using the $poly22$ structure is defined as:

$$\tau_2 = 1.374476 + 0.297182\tau_1 - 0.762376\nu - 0.018200\tau_1^2 + 0.143786\tau_1\nu + 0.158913\nu^2$$

This expression serves as the high-fidelity surface ($R^2 \approx 0.999$) that characterizes the system's temporal behavior across the parametric space.

### 5.2 The Explicit Identification Formula
By applying the quadratic inversion logic to the calibrated model above, the fractional order $\nu$ can be identified directly from measured time ratios $\tau_1$ and $\tau_2$ using the following analytical expression:

$$\nu = \frac{-(-0.7624 + 0.1438\tau_1) \pm \sqrt{(-0.7624 + 0.1438\tau_1)^2 - 0.635652(1.3745 + 0.2972\tau_1 - 0.0182\tau_1^2 - \tau_2)}}{0.317826}$$

### 5.3 Practical Identification Workflow
To utilize these results in the identification process, the following steps are performed:

1. **Feature Extraction:** Extract the specific time ratios $\tau_1$ and $\tau_2$ from the system's step response.
2. **Coefficient Calculation:** Compute the intermediate values for the linear term $B(\tau_1)$ and the independent term $C(\tau_1, \tau_2)$ using the calibrated constants.
3. **Root Selection:** Solve for $\nu$. Given the physical constraints of the master's thesis research (time identification of fractional order second species systems), only the root falling within the established range (typically $\nu \in [0.1, 2.0]$) is considered valid.

---
#FractionalControl #MasterThesis #SecondSpeciesSystems #Identification