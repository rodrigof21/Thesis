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
%
% OUTPUT FOLDER: (results\effectsOfWn_Plot) not yet
%==========================================================================

%% how does wn affect time?

w = 0:0.05:5;
%w = 1;
max_y = zeros(1, length(w));
tmax = zeros(1, length(w));
% parameters
nu = 0.2;
zeta = 0.2;

for i = 1:length(w)
    
    wn = w(i);

    % System (4)    
    G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

    u = @(s) 1./s;
    tfinal = 25;

    [tout, yout] = invFourierTrapz(G, u, tfinal, 0.05);
    [max_y(i), idx_max] = max(yout);
    tmax(i) = tout(idx_max);
end

figure, plot(tmax(3:end), w(3:end), 'DisplayName', 'results');
hold on

% w = a/tmax  => a = wn * tmax
a = mean(w.*tmax);

% Create the fit curve
%t_fit = linspace(min(tmax), max(tmax), 100);
wn_fit = a./tmax;

% Plot
plot(tmax, wn_fit, 'r--', 'DisplayName', sprintf('Fit: a/t, a = %.2f', a));

%legend('real', 'test')
legend('show')
xlabel('tmax')
ylabel('wn')


