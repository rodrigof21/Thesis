%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% testing the function [[identify2.m]] by looping through a range of values
% and measuring the rms for each one
%
% OUTPUT FOLDER: N/A
%==========================================================================

% nu_values = 0.01:0.02:2.0;
% zeta_values = 0.01:0.05:5.0;

nu_values = 0.01:0.05:2;
zeta_values = 0.01:0.05:3;

rms0 = zeros(length(nu_values), length(zeta_values));
rms1 = zeros(length(nu_values), length(zeta_values));
wn = 1;
u = @(s) 1./s;
total = length(nu_values)*length(zeta_values);
count = 1;

guess0 = zeros(length(nu_values), length(zeta_values), 2);
guess1 = zeros(length(nu_values), length(zeta_values), 2);
err_nu = zeros(length(nu_values), length(zeta_values), 2);
err_zeta = zeros(length(nu_values), length(zeta_values), 2);

for i = 1:length(nu_values)
    for j = 1:length(zeta_values)
        

        nu_real = nu_values(i);
        zeta_real = zeta_values(j);
 
        stable = checkStability(nu_real, zeta_real);
        if ~stable
            rms0(i,j) = inf;
            rms1(i,j) = inf;
            fprintf('Unstable\n');
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end
        
        [t02, t08, Mp] = extractPoints(nu_real, zeta_real, wn);

        if Mp == 0
            rms0(i,j) = inf;
            rms1(i,j) = inf;
            fprintf('non existing Mp\n')
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end

        if isnan(t02) || isnan(t08)
            rms0(i,j) = inf;
            rms1(i,j) = inf;
            fprintf('non existing time\n')
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end

        [nu_g0, zeta_g0, nu_g1, zeta_g1] = identify2(t02, t08, Mp);

        % fprintf('nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
        % fprintf('nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);

        guess0(i, j, 1) = nu_g0;
        guess0(i, j, 2) = zeta_g0;
        guess1(i, j, 1) = nu_g1;
        guess1(i, j, 2) = zeta_g1;
        err_nu(i, j, 1) = nu_real - nu_g0;
        err_nu(i, j, 2) = nu_real - nu_g1;
        err_zeta(i, j, 1) = zeta_real - zeta_g0;
        err_zeta(i, j, 2) = zeta_real - zeta_g1;
        
        G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
        G_guess0 = @(s) 1 ./ (1 + 2.*zeta_g0.*(s/wn).^nu_g0 + (s/wn).^(nu_g0+1));
        G_guess1 = @(s) 1 ./ (1 + 2.*zeta_g1.*(s/wn).^nu_g1 + (s/wn).^(nu_g1+1));
        
        [t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
        [t_guess0, y_guess0] = invFourierTrapz(G_guess0, u, 60, 0.05);
        [t_guess1, y_guess1] = invFourierTrapz(G_guess1, u, 60, 0.05);
        
        % % Debug Options
        % figure
        % plot(t_real, y_real, 'DisplayName', 'real'), hold on
        % plot(t_guess, y_guess, 'DisplayName', 'guess');
        % legend('show')
        % 
        % % Display values
        % fprintf('real: nu = %.2f, zeta=%.2f\n', nu_real, zeta_real)
        % fprintf('guess: nu = %.2f, zeta=%.2f\n', nu_g, zeta_g)
    
        % RMS
        err0 = y_real - y_guess0;
        err1 = y_real - y_guess1;
        rms0(i,j) = sqrt(mean(err0.^2));
        rms1(i,j) = sqrt(mean(err1.^2));
        fprintf('RMS0 = %.6f\n', rms0(i,j));
        fprintf('RMS1 = %.6f\n', rms1(i,j));
        fprintf('%.i/%.i\n', count, total);
        count = count+1;
    end
end
 