%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE:
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Loops through various nu and zeta to check the scale factor of wn. same
% as [[effectsOfWn_Plot]] but for all stable values of nu and zeta
%
% OUTPUT FOLDER: results/effectsOfWn
%==========================================================================

% Save config
outputFolder = 'results/effectsOfWn';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Stable values for nu and zeta
nu_init = 0.0:0.2:2;
zeta_init = 0.0:0.2:2; 
[nu_st, zeta_st] = filterUnstablePairs(nu_init, zeta_init);

% a factor vector
a = zeros(1, length(nu_st));

% progress check vars
total = length(nu_st);
count = 1;

for k = 1:length(nu_st)
    
    nu = nu_st(k);
    zeta = zeta_st(k);

    % wn iterations
    w = 0:0.05:5;
    
    max_y = zeros(1, length(w));
    tmax = zeros(1, length(w));
    
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

% w = a/tmax  => a = wn * tmax
a(k) = mean(w.*tmax);
wn_fit = a(k)./tmax;

% plot figure and save
h = figure('Visible','off');
plot(tmax(3:end), w(3:end), 'DisplayName', 'results');
hold on
plot(tmax, wn_fit, 'r--', 'DisplayName', sprintf('Fit: a/t, a = %.2f', a(k)));
legend('show')
xlabel('tmax')
ylabel('wn')
title(sprintf('scale factor of wn nu=%.1f zeta=%.1f', nu, zeta))
fileName = sprintf('effect_of_wn_nu%.1f_zeta%.1f.png', nu, zeta);
saveas(h, fullfile(outputFolder, fileName));
close(h);

% Progress
fprintf(sprintf("Done %i/%i\n", count, total))
count = count+1;
end

