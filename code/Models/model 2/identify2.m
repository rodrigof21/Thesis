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


function [nu_guess, zeta_guess] = identify2(t02, t05, t08)
    
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\model2.mat')
    fit_nu = idModel2.step1;
    fit_zeta = idModel2.step2;
    
    tau = t08/t02;
    tau2 = (t08-t05)./(t05-t02);

    nu_guess = fit_nu(log(tau), log(tau2));
    zeta_guess = fit_zeta(log(tau), nu_guess);

end

