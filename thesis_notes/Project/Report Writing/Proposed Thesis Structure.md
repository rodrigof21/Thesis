
### Chapter 1: Introduction
* **1.1. Motivation:** Why fractional-order modeling is becoming the standard for complex systems.
* **1.2. Problem Statement:** The difficulty of identifying parameters ($\nu, \zeta, \omega_n$) in the time domain compared to integer-order systems.
* **1.3. Objectives:** Establishing a systematic identification procedure based on step response regularities.
* **1.4. Thesis Contributions:** A novel real-time approach to parameter estimation.
* **1.5. Document Structure.**

---

### Chapter 2: State of the Art (Literature Review)
* **2.1. Overview of Fractional Calculus in Engineering:** Brief history and main applications.
* **2.2. Identification Methods for FOS:** * Frequency-domain techniques (Bode-based).
    * Time-domain optimization (Genetic Algorithms, PSO).
    * Current gaps in low-complexity real-time identification.
* **2.3. Fractional-Order Controllers:** Brief review of FO-PID and its dependence on accurate model identification.

---

### Chapter 3: Theoretical Background
* **3.1. Mathematical Foundations:** Definitions of Caputo and Riemann-Liouville derivatives.
* **3.2. Second Species Fractional Systems:** * The Transfer Function: $G(s) = \frac{\omega_n^2}{s^{2\nu} + 2\zeta\omega_n s^\nu + \omega_n^2}$.
    * Stability analysis and the $\nu$ range for physical systems.
* **3.3. Frequency Response:** Analytical derivation of Bode diagrams.

---

### Chapter 4: Characterization of the Fractional Step Response
* **4.1. Numerical Methods for Time Response:** From Frequency Response to Unit Step (using IFFT or specialized solvers).
* **4.2. Influence of $\omega_n$:** Mathematical proof of $\omega_n$ as a time-scale factor.
* **4.3. Parametric Analysis via Nested Loops:** * Systematic variation of $\nu$ (order) and $\zeta$ (damping).
    * Data collection and visualization of response families.
* **4.4. Feature Extraction:** * Defining critical points: Overshoot ($M_p$), Peak Time ($t_{M_p}$), and Mid-point ($t_{0.5}$).


---

### Chapter 5: Proposed Identification Procedure
* **5.1. Finding Regularities:** Analysis of the relationship between $(\nu, \zeta)$ and temporal metrics (Linear, Quadratic, and Exponential trends).
* **5.2. The Identification Algorithm:** A step-by-step heuristic to estimate parameters without heavy optimization.
* **5.3. Performance Evaluation:** Testing the algorithm across different stable regions.
* **5.4. Robustness Analysis:** Sensitivity to noise (SNR variations).

---

### Chapter 6: Real-Time Implementation and Control
* **6.1. Iterative Identification Logic:** Adapting the algorithm for streaming data.
* **6.2. Controller Design:** Real-time tuning of a controller based on the identified plant model.
* **6.3. Case Studies:** Validation of the closed-loop performance.

---

### Chapter 7: Conclusions and Future Work
* **7.1. Summary of Results.**
* **7.2. Final Reflections:** Advantages and limitations of the regularity-based approach.
* **7.3. Future Research Directions.**

---

### References
### Appendices (Code, Data Tables, etc.)



### Thesis Page Count Estimation (Target: ~80-100 Pages)

| Section | Estimated Pages | Content Overview |
| :--- | :---: | :--- |
| **Front Matter** | 8 - 10 | Cover, Abstract, Acknowledgments, Lists of Figures/Tables. |
| **Chapter 1: Introduction** | 5 - 7 | Problem context, objectives, and original contributions. |
| **Chapter 2: State of the Art** | 10 - 12 | Literature review on FOS and current identification methods. |
| **Chapter 3: Theoretical Background** | 10 - 15 | Mathematical definitions (Caputo), Stability, and Transfer Functions. |
| **Chapter 4: System Characterization** | 15 - 20 | Bode plots, Step response loops ($\nu, \zeta$), and $\omega_n$ scaling proof. |
| **Chapter 5: Identification & Results** | 12 - 15 | Regularity analysis, the proposed algorithm, and SNR/Noise tests. |
| **Chapter 6: Real-time & Control** | 8 - 10 | Iterative implementation and FO-PID tuning (with Juan Gude). |
| **Conclusions & References** | 5 - 7 | Summary of findings and bibliographic list. |
| **Appendices** | 5 - 10 | MATLAB/Python scripts and extensive data tables. |
| **TOTAL ESTIMATED** | **~78 - 106** | |
