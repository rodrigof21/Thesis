%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: Function
% STATUS: GAVE UP
%
% PROGRAM DESCRIPTION: 
% Uses the Model 1 to identify a give system.
%
% OUTPUT FOLDER:
%==========================================================================

function [nu_guess, zeta_guess] = identifyModel1(t02, t05, t08)
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\idModel_1\model1.mat');

    step1 = idModel1.NuStep1;
    step2 = idModel1.NuStep2;
    final = idModel1.ZetaFinal;

    zeta_init = 0.5;

    p00 = 
    

end