
file [[varyingWn.m]]:
## System (99)

![[Pasted image 20260211135859.png|477]]

![[Pasted image 20260223141444.png|480]]
## System (4)

**$\omega_n$ acts as a scale factor in time.**

![[Pasted image 20260211153730.png|530]]

$\omega_n = [0.5, 0.7, 1.0, 1.5, 2.0, 5.0]$:

![[Pasted image 20260228122624.png|394]]![[Pasted image 20260228122639.png|160]]


> [!warning] Peak time
> I'm checking how wn affects the tp overshoot time but some systems may not have one, thus the weird results
> could try to change to ss value time



## In what way does it affect the peak time?

was able to fit a curve in [[effectsOfWn_Plot.m]] for $\nu = 1.4, \zeta = 0.2$

![[Pasted image 20260228130220.png|389]]

Looks like an inverse function $y = \frac{1}{x}$ 

![[Pasted image 20260228132727.png|348]] ![[Pasted image 20260228160245.png|341]]
 
now loops through every stable value of nu and zeta in [[effectsOfWn.m]]:

$$\omega_n \approx \frac{a}{t}$$
$$a = t\cdot\omega_n \equiv a \approx mean(t\cdot\omega_n)$$

also tested with lscurvefit in [[effectsOfWn_Plot.m]]

> [!info] Value of $a$
> It probably depends on $\nu$ and/or $\zeta$


## evaluating with peak vs. t05
coefficient results are different 

![[Pasted image 20260228173825.png]]