[[curveFit_test.m]]
## 1. Estimativa da Ordem Fracionária ($\nu$)

A ordem fracionária é calculada em função dos tempos de subida de 20% e 80%. A relação é linear (plano), mas os coeficientes do plano variam com o amortecimento ($\zeta$).

### Equação Principal
$$\nu(t_{0.2}, t_{0.8}, \zeta) = p_{00}(\zeta) + p_{10}(\zeta) \cdot t_{0.2} + p_{01}(\zeta) \cdot t_{0.8}$$

### Evolução dos Coeficientes
Cada coeficiente $p_{ij}$ é determinado por um polinómio de 3º grau em função de $\zeta$:

* **Termo Independente:** $p_{00}(\zeta) = a_1 \zeta^3 + a_2 \zeta^2 + a_3 \zeta + a_4$
* **Sensibilidade a $t_{0.2}$:** $p_{10}(\zeta) = b_1 \zeta^3 + b_2 \zeta^2 + b_3 \zeta + b_4$
* **Sensibilidade a $t_{0.8}$:** $p_{01}(\zeta) = c_1 \zeta^3 + c_2 \zeta^2 + c_3 \zeta + c_4$

---

## 2. Estimativa do Amortecimento ($\zeta$)

O amortecimento é calculado através de uma superfície global de segunda ordem (`poly22`), utilizando o tempo de subida de 50% e a ordem fracionária $\nu$ identificada no passo anterior.

### Equação Global
$$\zeta(t_{0.5}, \nu) = q_{00} + q_{10} t_{0.5} + q_{01} \nu + q_{20} t_{0.5}^2 + q_{11} t_{0.5} \nu + q_{02} \nu^2$$

---
