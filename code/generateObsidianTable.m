nu_v = 0.1:0.1:1.2;
zeta_v = 0.0:0.1:1.2;

% Nome do ficheiro de saída
fileID = fopen('tabela_simulacoes_visual.md', 'w');

% Cabeçalho da tabela com coluna de Pré-visualização
fprintf(fileID, '| Sim | Preview | $\\nu$ | $\\zeta$ |\n');
fprintf(fileID, '| :--- | :---: | :---: | :---: |\n');

count = 1;
for i = 1:length(nu_v)
    for j = 1:length(zeta_v)
        nu = nu_v(i);
        zeta = zeta_v(j);
        
        % Nome da imagem conforme gerado no script anterior
        imgName = sprintf('stepResponse_nu%.1f_zeta%.1f.png', nu, zeta);
        
        % Escrita da linha com o link de imagem do Obsidian ![[nome|tamanho]]
        % O tamanho |150 garante que a tabela não fique gigante
        fprintf(fileID, '| `sim_%d` | ![[%s\\|300]] | %.1f | %.1f |\n', ...
                count, imgName, nu, zeta);
        
        count = count + 1;
    end
end

fclose(fileID);
fprintf('Tabela visual gerada para o Obsidian: tabela_simulacoes_visual.md\n');