%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% checks the effect of varying wn 
% Plots the curve fitting for a specific value of nu and zeta
% Can choose if we want to measure the time difference between overshoot
% peaks (that may not exist) or t05
%
% OUTPUT FOLDER: (results\effectsOfWn_Plot) not yet
%==========================================================================


hFig = figure('Visible','on');
fprintf('Select Mode: Peak(p) or t05(t)\n')
waitforbuttonpress;
key = get(hFig, 'CurrentKey');
if key == 'p'
    mode = 0;
    fprintf('Peak Selected\n')
elseif key == 't'
    mode = 1;
    fprintf('t05 Selected\n')
end

w = 0.5:0.05:5;
%w = 1;
max_y = zeros(1, length(w));
teval = zeros(1, length(w));

% parameters
nu = 1.2;
zeta = 0.5;
stable = checkStability(nu, zeta);
if stable, fprintf('Stable\n')
else, fprintf('Unstable\n'), close(hFig), return
end


for i = 1:length(w)
    
    wn = w(i);
 
    G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

    u = @(s) 1./s;
    tfinal = 30;
    [tout, yout] = invFourierTrapz(G, u, tfinal, 0.05);

    if mode == 0
        % regarding Overshoot
        [max_y(i), idx_max] = max(yout);
        teval(i) = tout(idx_max);
    elseif mode == 1
        % regarding t05
        idx05 = find(yout >= 0.5, 1); %the first value over or = to 0.5
        teval(i) = tout(idx05);
    end
end

plot(teval(3:end), w(3:end), 'DisplayName', 'results');
hold on

% w = a/tmax  => a = wn * tmax
a = mean(w.*teval);

% Create the fit curve
%t_fit = linspace(min(tmax), max(tmax), 100);
wn_fit = a./teval;

% Plot
plot(teval, wn_fit, 'r--', 'DisplayName', sprintf('Fit: a/t, a = %.2f', a));

% curve fitting y = a/(x+b)
model = @(coeff, x) coeff(1)./x + coeff(2);
x0 = [1, 0]; 
coeffs = lsqcurvefit(model, x0, teval(3:end), w(3:end));
wn_fit = model(coeffs, teval);
plot(teval, wn_fit, 'g-', 'DisplayName', sprintf('lscurve: a = %.2f b = %.2f', coeffs(1), coeffs(2)));

%legend('real', 'test')
legend('show')
xlabel('t')
ylabel('wn')
fprintf('Complete\n')
if mode == 0
    title('wn vs tp')
elseif mode == 1
    title('wn vs t05')
end


