
Let's consider the following case:

$$ G(s) = \frac{1}{s + 1}$$

Considering the unit step response:

$$ Y(s) = \frac{1}{s+1} \times\frac{1}{s}$$
and

$$ Y(j\omega) = \frac{1}{j\omega+1} \times\frac{1}{j\omega}$$

in the time domain:

$$y(t) = \mathcal{F}^{-1}\{Y(j\omega)\} = \frac{1}{2\pi}\int Y(j\omega) \cdot e^{j\omega t} \, d\omega$$

Riemann's integral:

$$y(t) \approx \frac{1}{2\pi}\sum Y(j\omega)\cdot e^{j\omega t} \Delta \omega $$
	Apply in matlab