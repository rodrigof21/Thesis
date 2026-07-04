%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Function to identify systems with Model 2
%
% OUTPUT FOLDER: NA
%==========================================================================


function [nu_guess, zeta_guess] = identify3(t02, t05, t08)
    
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 3\model3.mat')
    fit_zeta = idModel3.step1;
    fit_nu = idModel3.step2;

    zeta_guess = fit_zeta(t05, t08);
    nu_guess = fit_nu(t02, zeta_guess);

end
