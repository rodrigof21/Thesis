%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Loops through various nu and zeta to check the scale factor of wn. same
% as [[effectsOfWn_Plot.m]] but for all stable values of nu and zeta
%
% OUTPUT FOLDER: results/effectsOfWn
%                results/effectsOfWn_coefficients
%==========================================================================

% Save config
outputFolder = 'results/effectsOfWn';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Stable values for nu and zeta
nu_init = 0.1:0.2:2;
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
    w = 0.5:0.1:5;
    
    max_y = zeros(1, length(w));
    teval = zeros(1, length(w));
    
    for i = 1:length(w)
        
        wn = w(i);
    
        % System (4)    
        G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
    
        u = @(s) 1./s;
        tfinal = 60;
        [tout, yout] = invFourierTrapz(G, u, tfinal, 0.05);

        % [max_y(i), idx_max] = max(yout);
        % teval(i) = tout(idx_max);

        idx05 = find(yout >= 0.5, 1);
        teval(i) = tout(idx05);
        %teval(i) = interp1(yout, tout, 0.5);

    end
    
    h = figure('Visible','off');
    plot(teval(3:end), w(3:end), 'DisplayName', 'results');
    hold on

    % y = a/x guess
    % w = a/tmax  => a = wn * tmax
    a(k) = mean(w.*teval);
    wn_fit = a(k)./teval;
    plot(teval, wn_fit, 'r--', 'DisplayName', sprintf('Fit: a/t, a = %.2f', a(k)));
    
    % % curve fitting y = a/(x+b)
    % model = @(coeff, x) coeff(1)./x + coeff(2);
    % x0 = [1, 0]; 
    % coeffs = lsqcurvefit(model, x0, tmax(3:end), w(3:end));
    % wn_fit = model(coeffs, tmax);
    % plot(tmax, wn_fit, 'g-', 'DisplayName', sprintf('lscurve: a = %.2f b = %.2f', coeffs(1), coeffs(2)));

    % Config and save
    legend('show');
    xlabel('t05')
    ylabel('wn')
    title(sprintf('scale factor of wn vs t05 nu=%.1f zeta=%.1f', nu, zeta))
    fileName = sprintf('effect_of_wn_nu%.1f_zeta%.1f.png', nu, zeta);
    saveas(h, fullfile(outputFolder, fileName));
    close(h);
    
    % Progress
    fprintf(sprintf("Done %i/%i\n", count, total))
    count = count+1;
end

