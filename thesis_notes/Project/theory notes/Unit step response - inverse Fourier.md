
from gemini

# Fractional System Step Response Theory

This document outlines the methodology for obtaining the time-domain unit step response from the frequency-domain representation of a second-species fractional system, based on the principles of Signals and Systems.

## 1. The Frequency Domain Foundation
The unit step response $y(t)$ is the output of a system $G(s)$ when subjected to an input $U(s) = \frac{1}{s}$. In the frequency domain, we substitute $s = j\omega$:

$$Y(j\omega) = G(j\omega) \cdot \frac{1}{j\omega}$$

For the **second-species fractional system**, the transfer function is defined as:

$$G(j\omega) = \frac{\omega_n^2}{(j\omega)^{\nu+1} + 2\zeta\omega_n(j\omega)^\nu + \omega_n^2}$$

The fractional term $(j\omega)^\nu$ is calculated using the complex identity:
$$(j\omega)^\nu = \omega^\nu \left( \cos\frac{\nu\pi}{2} + j \sin\frac{\nu\pi}{2} \right)$$



---

## 2. Inverse Fourier Transform (Manual Integration)
To move from the frequency domain $Y(j\omega)$ to the time domain $y(t)$ without using automated "black-box" functions (like `ifft`), we apply the **Inverse Fourier Transform** definition:

$$x(t) = \mathcal{F}^{-1}\{X(j\omega)\} = \frac{1}{2\pi} \int_{-\infty}^{+\infty} X(j\omega) e^{j\omega t} d\omega$$

### Numerical Simplification
Since the resulting time signal $y(t)$ must be real-valued, we can use the **Sine Transform** version of the inverse integral. This is numerically stable for step responses and avoids complex-plane singularities at $\omega=0$:

$$y(t) = \frac{2}{\pi} \int_{0}^{\infty} \frac{\text{Re}[G(j\omega)]}{\omega} \sin(\omega t) d\omega$$

Where:
* $\text{Re}[G(j\omega)]$ is the real part of the system's frequency response.
* $\omega$ is the angular frequency in rad/s.
* $t$ is the specific time instant being calculated.



---

## 3. Discretization for MATLAB Implementation
To implement this manually, the integral is approximated as a finite **Riemann Sum**:

$$y(t) \approx \frac{2}{\pi} \sum_{k=1}^{N} \left( \frac{\text{Re}[G(j\omega_k)]}{\omega_k} \sin(\omega_k t) \right) \Delta\omega$$

### Parameters for Accuracy
* **$\Delta\omega$ (Frequency Step):** Must be small enough to capture the resonance peak (e.g., $0.01$ rad/s).
* **$\omega_{max}$:** The upper limit of the summation must be high enough that the magnitude $|G(j\omega)|$ has significantly rolled off.

---

## 4. Verification Case (Integer Order)
To validate the manual code, we use a standard second-order system where $\nu=1$:
$$G(s) = \frac{1}{s^2 + 2s + 4}$$
The theoretical unit step response for this underdamped case ($\zeta = 0.5$) is:
$$y(t) = 0.25 \left( 1 - e^{-t} \cos(\sqrt{3}t) - \frac{1}{\sqrt{3}} e^{-t} \sin(\sqrt{3}t) \right)$$