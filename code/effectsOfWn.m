%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
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

        idx05 = find(yout >= 0.5, 1);
        teval(i) = tout(idx05);

    end

    a(k) = mean(w.*teval);
    wn_fit = a(k)./teval;

    % Progress
    fprintf(sprintf("Done %i/%i\n", count, total))
    count = count+1;
end


wnid_data = [a' nu_st' zeta_st'];


