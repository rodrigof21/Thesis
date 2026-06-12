


  $$U = C \cdot E$$
  $$U = C \cdot (R - Y)$$
	  $$U = C \cdot (R - G \cdot U)$$
  $$U + C \cdot G \cdot U = C \cdot R$$  
  $$U \cdot (1 + C \cdot G) = C \cdot R$$
* **Final Actuator Equation:** $$\frac{U}{R} = \frac{C}{1 + C \cdot G}$$




**3. The MATLAB "Trick"**
The `feedback(top, bottom)` function in MATLAB is essentially a fraction calculator that always applies this fixed rule:  
$$\text{Result} = \frac{\text{top}}{1 + \text{top} \cdot \text{bottom}}$$

To force MATLAB to generate our **Final Actuator Equation**, we just need to match the variables:
* `top` = $C$
* `bottom` = $G$

**Conclusion:** The command `U_tf = feedback(C, G_plant)` does not change the physical wiring of the closed-loop system. It is simply a coding shortcut that prompts MATLAB to instantly build the mathematical fraction $\frac{C}{1 + C \cdot G}$, allowing us to simulate the actuator's step response.