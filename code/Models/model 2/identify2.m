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


function [nu_guess0, zeta_guess0, nu_guess1, zeta_guess1] = identify2(t02, t05, t08)
    
    load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\model2.mat')
    fit_nu0 = idModel2.step1;
    fit_nu1 = idModel2.step2;
    fit_zeta = idModel2.step3;
    
    tau = t08./t02;
    tau2 = t05./t02;

    nu_guess0 = fit_nu0(log(tau), log(tau2));
    zeta_guess0 = fit_zeta(log(tau), nu_guess0);

    nu_guess1 = fit_nu1(log(tau), log(tau2));
    zeta_guess1 = fit_zeta(log(tau), nu_guess1);

end

