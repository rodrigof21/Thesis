%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% First test at identifying a System using the [[idModel_auto.m]] script
%
% INPUTS:
%   - t02, t05, t08: measured values
%   - F_nu and F_zeta models
%
% OUTPUTS:
%   - nu, zeta
%
% OUTPUT FOLDER: N/A
%==========================================================================

function [nu, zeta] = identifyModelAuto(t02, t05, t08)
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\idModel_test\F_nu.mat')
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\idModel_test\F_zeta.mat')
    nu = F_nu(t02, t08);
    zeta = F_zeta(t05, nu);
    fprintf('Identified system: nu = %.3f, zeta = %.3f\n', nu, zeta);
end
