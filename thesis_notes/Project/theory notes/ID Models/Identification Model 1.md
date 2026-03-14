[[idModel_1.m]]

- Done using the `fit` function
- all using polynomial curves
## 1. $\nu$ Model

The fractional order is calculated with t02 and t08
### Equation:
$$\nu(t_{0.2}, t_{0.8}, \zeta) = p_{00}(\zeta) + p_{10}(\zeta) \cdot t_{0.2} + p_{01}(\zeta) \cdot t_{0.8}$$

### Coefficients by $\zeta$ 
Each coefficient $p_{ij}$ is determined by a 3rd order poly as a function of $\zeta$

* **independent term:** $p_{00}(\zeta) = a_1 \zeta^3 + a_2 \zeta^2 + a_3 \zeta + a_4$
* **$t_{0.2}$ term:** $p_{10}(\zeta) = b_1 \zeta^3 + b_2 \zeta^2 + b_3 \zeta + b_4$
* **$t_{0.8}$: term** $p_{01}(\zeta) = c_1 \zeta^3 + c_2 \zeta^2 + c_3 \zeta + c_4$
---

## 2. $\zeta$ Model

The damping coeff is determined with t05 and $\nu$ using `poly22`
### Equation:
$$\zeta(t_{0.5}, \nu) = q_{00} + q_{10} t_{0.5} + q_{01} \nu + q_{20} t_{0.5}^2 + q_{11} t_{0.5} \nu + q_{02} \nu^2$$

---
		x\
![[Pasted image 20260314102552.png|416]]
![[Pasted image 20260314102616.png|419]]


Results
