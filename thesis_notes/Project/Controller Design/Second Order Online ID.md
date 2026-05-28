
### General theory

Generic Second order System:

$$
G(s)=\frac{\omega_n^2}{s^2+2\xi s+ \omega_n^2}  
$$

After discretizing with sample time $T_s$ 

$$G(z)=\frac{b_1 z^{-1}+b_2 z^{-2}}  
{1+a_1 z^{-1}+a_2 z^{-2}}$$
In the time domain:


$$y(k)=  
-a_1 y(k-1)  
-a_2 y(k-2)  
+b_1 u(k-1)  
+b_2 u(k-2)$$

$$a(k)=  
\begin{bmatrix}  
u(k-1) \\  
u(k-2) \\  
-y(k-1) \\  
-y(k-2)  
\end{bmatrix}$$
and
$$\theta=  
\begin{bmatrix}  
b_1 \\  
b_2 \\  
a_1 \\  
a_2  
\end{bmatrix}$$

Which yields:

$$y = \theta \cdot a_k$$

### Online ID

$$
\begin{align}
\boldsymbol{\theta}_k &= \boldsymbol{\theta}_{k-1} + \alpha_k \mathbf{R}_k^{-1}\mathbf{a}_k^T (y_k - \mathbf{a}_k\boldsymbol{\theta}_{k-1}) \tag{31.53} \\
\mathbf{R}_k &= \mathbf{R}_{k-1} + \alpha_k \mathbf{a}_k^T \mathbf{a}_k \tag{31.54}
\end{align}
$$

	
### Simulink Implementaiton

![[Pasted image 20260527110932.png]]


```
function [theta,R] = online_ID(theta_old, R_old, a, err)

	% forgetting factor
	alpha = 1;
	
	if isempty(R_old)
		R_old = eye(4) * 0.001;
		theta_old = zeros(4,1);
	end
	
	R = R_old + alpha*(a*a');
	theta = theta_old + alpha*(R\a)*err;

end
```

