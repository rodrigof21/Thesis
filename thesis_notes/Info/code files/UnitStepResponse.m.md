## Description

THESIS PROJECT: Time-Domain Identification of Second-Species Systems
AUTHOR: Rodrigo Fonseca
DATE: 2026
TYPE: SCRIPT
STATUS: FINISHED

PROGRAM DESCRIPTION:
This program uses the [[invFourierTest.m]] function to compute the unit
step response of various systems by looping through various values of
zeta and nu. The values of each iteration are stored in
[[Database Values]].

INPUTS:
- N/A

OUTPUTS:
- step response database in a .mat file

OUTPUT FOLDER: results/unitStepResponses_img

MODEL TYPE: G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

---
**Source Path:** `C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code\UnitStepResponse.m`