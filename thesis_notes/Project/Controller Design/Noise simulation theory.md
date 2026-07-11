
## Closed loop

$$y(s) = T(s),R(s) - T(s),N(s)$$

- $R(s)$ — reference
- $N(s)$ — sensor noise
- $T(s) = \dfrac{C(s)G(s)}{1+C(s)G(s)}$

The negative sign appears because the controller sees the error $r - (y+n)$, not $r-y$.

## Superposition principle

Linear system → response to two inputs = sum of responses to each input alone.

$$y_{total} = \underbrace{T(s)R(s)}_{y_{ref}} + \underbrace{(-T(s))N(s)}_{y_{noise}}$$

## Implementation

```matlab
y_ref   = lsim(T_ry, r, t_sim);
y_noise = lsim(-T_ry, n_sensor, t_sim);
y_total = y_ref + y_noise;
```

Equivalent to simulating $r$ and $n$ simultaneously.

## Usefulness

Allows isolating:

- $y_{ref}$ → reference tracking quality
- $y_{noise}$ → sensitivity to measurement noise

Useful for showing the effect of the filter $T_f$ specifically on the noise component.