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

nu_init = 0.0:0.02:2; 
zeta_init = 0.0:0.05:5; 
wn = 1;
u = @(s) 1./s;

[nu_v, zeta_v] = filterUnstablePairs(nu_init, zeta_init);

total_estaveis = length(nu_v);
data_storage = struct();

fprintf('A gerar base de dados estruturada. Total estáveis a simular: %d\n', total_estaveis);


tic;
for k = 1:total_estaveis
    
    nu_atual   = nu_v(k);
    zeta_atual = zeta_v(k);
    
    G = @(s) 1 ./ (1 + 2.*zeta_atual.*(s/wn).^nu_atual + (s/wn).^(nu_atual+1));
    
    tfinal = 60;
    ts = 0.01;
    [t, y] = invFourierTrapz(G, u, tfinal, ts);
    
    fieldName = sprintf('sim_%d', k);
    data_storage.(fieldName).nu = nu_atual;
    data_storage.(fieldName).zeta = zeta_atual;
    data_storage.(fieldName).t = t;
    data_storage.(fieldName).y = y;
    
    if mod(k, 10) == 0 || k == total_estaveis
        fprintf('Progresso: %d / %d sistemas simulados.\n', k, total_estaveis);
    end
end
toc;

save(fullfile(outputFolder, 'step_response_database.mat'), 'data_storage');
fprintf('Base de dados concluída com sucesso! Ficheiro gravado.\n');