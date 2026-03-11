%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
% EXTRATOR DE COEFICIENTES PARA OBSIDIAN/THESIS
%==========================================================================

fprintf('\n# Coeficientes do Modelo de Identificação\n\n');

% --- TABELA A: Nu (Model_pvszeta - poly3) ---
fprintf('## Tabela A: Parâmetros de nu (Ajuste poly3 em função de zeta)\n');
fprintf('| Coeficiente | zeta^3 | zeta^2 | zeta^1 | Constante |\n');
fprintf('| :--- | :--- | :--- | :--- | :--- |\n');

% Extrair coeficientes [p1 p2 p3 p4] de cada fit
c00 = coeffvalues(Model_pvszeta.p00_fit);
c10 = coeffvalues(Model_pvszeta.p10_fit);
c01 = coeffvalues(Model_pvszeta.p01_fit);

fprintf('| **p00** | %.6f | %.6f | %.6f | %.6f |\n', c00(1), c00(2), c00(3), c00(4));
fprintf('| **p10** | %.6f | %.6f | %.6f | %.6f |\n', c10(1), c10(2), c10(3), c10(4));
fprintf('| **p01** | %.6f | %.6f | %.6f | %.6f |\n\n', c01(1), c01(2), c01(3), c01(4));

% --- TABELA B: Zeta (fit_zeta - poly22) ---
fprintf('## Tabela B: Parâmetros de zeta (Ajuste poly22: f(t05, nu))\n');
fprintf('| Coeficiente | Valor | Descrição |\n');
fprintf('| :--- | :--- | :--- |\n');

% No poly22 do MATLAB os coeficientes seguem a ordem: 
% p00, p10, p01, p20, p11, p02
cz = coeffvalues(fit_zeta);

fprintf('| q00 | %.6f | Intercepto |\n', cz(1));
fprintf('| q10 | %.6f | Termo linear t05 |\n', cz(2));
fprintf('| q01 | %.6f | Termo linear nu |\n', cz(3));
fprintf('| q20 | %.6f | Termo quadrático t05^2 |\n', cz(4));
fprintf('| q11 | %.6f | Interação t05 * nu |\n', cz(5));
fprintf('| q02 | %.6f | Termo quadrático nu^2 |\n\n', cz(6));

fprintf('--- \n*Gerado automaticamente em: %s*\n', datestr(now));