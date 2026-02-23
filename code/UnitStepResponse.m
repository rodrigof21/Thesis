%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% This program uses the [[invFourierTest.m]] function to compute the unit
% step response of various systems by looping through various values of
% zeta and nu. The values of each iteration are stored in 
% [[Database Values]].
%
% INPUTS:
%   - N/A
%
% OUTPUTS:
%   - step response database in a .mat file
%
% OUTPUT FOLDER: results/unitStepResponses_img
%
% MODEL TYPE: G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
%==========================================================================


outputFolder = 'results/unitStepResponses';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

nu_v = 0.1:0.1:2;
zeta_v = 0.0:0.1:2;
wn = 1;

u = @(s) 1./s;

count = 1;
total = length(nu_v)*length(zeta_v);

data_storage = struct();

for i = 1:length(nu_v)
    for j = 1:length(zeta_v)
        
        nu = nu_v(i);
        zeta = zeta_v(j);

        G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
        
        tfinal = 60;
        ts = 0.01;

        [t, y] = invFourierTrapz(G, u, tfinal, ts);
        
        % Guardar na estrutura
        fieldName = sprintf('sim_%d', count);
        data_storage.(fieldName).nu = nu;
        data_storage.(fieldName).zeta = zeta;
        data_storage.(fieldName).t = t;
        data_storage.(fieldName).y = y;
        

        fprintf('Status: %d/%d\n', count, total);
        count = count + 1;
    end
end

save(fullfile(outputFolder, 'step_response_database.mat'), 'data_storage');