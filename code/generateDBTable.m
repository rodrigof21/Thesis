%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: Generates a table with the values for each unit step
% response in the database and the respective image
%
%
% INPUTS: N/A
%
%
% OUTPUTS: N/A
%
%
% OUTPUT FOLDER: N/A
%==========================================================================


% Nome do ficheiro de saída
fileID = fopen('tabela_simulacoes_visual.md', 'w');

% Cabeçalho da tabela com coluna de Pré-visualização
fprintf(fileID, '| Sim | $\\nu$ | $\\zeta$ |\n');
fprintf(fileID, '| :--- | :---: | :---: |\n');

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\unitStepResponses\step_response_database.mat')
sims = fieldnames(data_storage);


count = 1;
for i = 1:length(sims)
    id_sim = sims{i}; % Ex: 'sim_1'
    dados = data_storage.(id_sim);

    % Extrair parâmetros
    nu = dados.nu;
    zeta = dados.zeta;
    
    fprintf(fileID, '| `sim_%d` | %.1f | %.1f |\n', ...
            count, nu, zeta);
    
    count = count + 1;
end

fclose(fileID);
fprintf('Tabela visual gerada para o Obsidian: tabela_simulacoes.md\n');