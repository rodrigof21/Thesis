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

nu_values = 0.01:0.02:2.0;
zeta_values = 0.01:0.05:5.0;
rms = zeros(length(nu_values), length(zeta_values));
wn = 1;
u = @(s) 1./s;
total = length(nu_values)*length(zeta_values);
count = 1;

guess = zeros(length(nu_values), length(zeta_values), 2);

for i = 1:length(nu_values)
    for j = 1:length(zeta_values)
        

        nu_real = nu_values(i);
        zeta_real = zeta_values(j);
 
        stable = checkStability(nu_real, zeta_real);
        if ~stable
            rms(i,j) = inf;
            fprintf('Unstable\n');
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end
        
        [t02, t05, t08] = extractPoints(nu_real, zeta_real);
        [nu_g, zeta_g] = identify2(t02, t05, t08);

        if t02 == 0 || t05 == 0 || t08 == 0
            rms(i,j) = inf;
            fprintf('non existing time\n')
            fprintf('%.i/%.i\n', count, total);
            count=count+1;
            continue
        end

        % fprintf('nu = %.2f and zeta = %.2f\n', nu_real, zeta_real);
        % fprintf('nu = %.2f and zeta = %.2f\n', nu_g, zeta_g);

        guess(i, j, 1) = nu_g;
        guess(i, j, 2) = zeta_g;
        
        G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));
        G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn).^nu_g + (s/wn).^(nu_g+1));
        
        [t_real, y_real] = invFourierTrapz(G_real, u, 60, 0.05);
        [t_guess, y_guess] = invFourierTrapz(G_guess, u, 60, 0.05);
        
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
        err = y_real - y_guess;
        rms(i,j) = sqrt(mean(err.^2));
        fprintf('RMS = %.6f\n', rms(i,j));
        fprintf('%.i/%.i\n', count, total);
        count = count+1;
    end
end
 