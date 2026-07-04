
>[!info] Important Considerations
>1. These models were fitted by applying the **logarithm to the gains** (except $T_f$)
>2. The Model for $T_f$ is not optimized yet, no solution found
>3.  $\nu$ and $\zeta$ have the same limits as in the ID
>4. Unstable Systems were disregarded
>5. The PSO's parameters were different depending on the value of $\nu$
>6. All the responses were simulated over 30s


Look for Tf rules (3* the bandwidth)
The design of high performance mechatronics Chapter 4, IOS Press

$$ \begin{aligned} \ln K_p(\nu, \zeta) = & \, i_{00} + i_{10}\nu + i_{01}\zeta + i_{20}\nu^2 + i_{11}\nu\zeta + i_{02}\zeta^2 \\ & + i_{30}\nu^3 + i_{21}\nu^2\zeta + i_{12}\nu\zeta^2 + i_{03}\zeta^3 \\ & + i_{40}\nu^4 + i_{31}\nu^3\zeta + i_{22}\nu^2\zeta^2 + i_{13}\nu\zeta^3 + i_{04}\zeta^4 \end{aligned} $$ $$ \begin{aligned} \ln K_i(\nu, \zeta) = & \, j_{00} + j_{10}\nu + j_{01}\zeta + j_{20}\nu^2 + j_{11}\nu\zeta + j_{02}\zeta^2 \\ & + j_{30}\nu^3 + j_{21}\nu^2\zeta + j_{12}\nu\zeta^2 + j_{03}\zeta^3 \\ & + j_{40}\nu^4 + j_{31}\nu^3\zeta + j_{22}\nu^2\zeta^2 + j_{13}\nu\zeta^3 + j_{04}\zeta^4 \end{aligned} $$ $$ \begin{aligned} \ln K_d(\nu, \zeta) = & \, k_{00} + k_{10}\nu + k_{01}\zeta + k_{20}\nu^2 + k_{11}\nu\zeta + k_{02}\zeta^2 \\ & + k_{30}\nu^3 + k_{21}\nu^2\zeta + k_{12}\nu\zeta^2 + k_{03}\zeta^3 \\ & + k_{40}\nu^4 + k_{31}\nu^3\zeta + k_{22}\nu^2\zeta^2 + k_{13}\nu\zeta^3 + k_{04}\zeta^4 \end{aligned} $$
**Coefficient Values**
$$ \begin{aligned} i_{00} &= -5.6247 & j_{00} &= -6.9005 & k_{00} &= 21.4505 \\ i_{10} &= 53.7088 & j_{10} &= 32.1442 & k_{10} &= -69.8475 \\ i_{01} &= -5.7332 & j_{01} &= -1.1613 & k_{01} &= -1.3450 \\ i_{20} &= -90.8012 & j_{20} &= -27.2632 & k_{20} &= 104.2419 \\ i_{11} &= 17.8105 & j_{11} &= -5.2447 & k_{11} &= -6.5825 \\ i_{02} &= -1.0406 & j_{02} &= 1.4202 & k_{02} &= 1.3810 \\ i_{30} &= 53.6594 & j_{30} &= 5.0987 & k_{30} &= -67.0631 \\ i_{21} &= -6.1779 & j_{21} &= 6.7786 & k_{21} &= 9.9699 \\ i_{12} &= -3.0594 & j_{12} &= -0.6656 & k_{12} &= -0.8404 \\ i_{03} &= 0.6594 & j_{03} &= -0.2603 & k_{03} &= -0.2175 \\ i_{40} &= -11.2542 & j_{40} &= 0.4624 & k_{40} &= 14.7323 \\ i_{31} &= 0.6150 & j_{31} &= -1.6179 & k_{31} &= -2.5883 \\ i_{22} &= 0.6637 & j_{22} &= -0.0449 & k_{22} &= -0.2434 \\ i_{13} &= 0.1265 & j_{13} &= 0.0596 & k_{13} &= 0.1624 \\ i_{04} &= -0.0647 & j_{04} &= 0.0190 & k_{04} &= 0.0009 \\ \end{aligned} $$

Goodness of fit:
$K_p$ $R^2 = 0.9311$
$K_i$ $R^2 = 0.9008$
$K_d$ $R^2 = 0.9023$
$T_f$ $R^2 = 0.5326$


---
### Example 1 - worst case

| $\nu$   | 1.9   |
| ------- | ----- |
| $\zeta$ | 1.7   |
| ITAE    | 18.88 |
| $K_p$   | 0.142 |
| $K_i$   | 0.988 |
| $K_d$   | 6.112 |
| $T_f$   | 98.13 |


![[Pasted image 20260624111945.png|609]]

---

### Example 2 - a good one

| $\nu$   | 1.1    |
| ------- | ------ |
| $\zeta$ | 1.8    |
| ITAE    | 0.108  |
| $K_p$   | 44.57  |
| $K_i$   | 8.21   |
| $K_d$   | 30.77  |
| $T_f$   | 100.75 |


![[Pasted image 20260624112729.png|697]]




#### Next steps

- Solve the Tf problem
	- T_f derivstive time divided by 10 ($t_d/10$)
	- $Tf = (K_d/10*K_p)$
	- 
- Fractional PIDs
- Real time ID and control

