%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: GAVE UP
%
% PROGRAM DESCRIPTION: 
% First test at a simple Identification Model
%
%
% OUTPUT FOLDER: results/idModel_test
%==========================================================================

outputFolder = 'results/idModel_test';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\results.mat')
%load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\comparePoints\CalibrationData.mat')


% 1. Criar interpolador para Nu: nu = f(t02, t08)
% Usamos os dados que guardaste na matriz 'results'
F_nu = scatteredInterpolant(results(:,2), results(:,4), results(:,5), 'linear', 'nearest');

% 2. Criar interpolador para Zeta: zeta = f(t05, nu)
F_zeta = scatteredInterpolant(results(:,3), results(:,5), results(:,6), 'linear', 'nearest');