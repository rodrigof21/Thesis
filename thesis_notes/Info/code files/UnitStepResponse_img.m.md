## Description

THESIS PROJECT: Time-Domain Identification of Second-Species Systems
AUTHOR: Rodrigo Fonseca
DATE: 2026
TYPE: SCRIPT
STATUS: FINISHED

PROGRAM DESCRIPTION:
This program uses the [[invFourierTest.m]] function to compute the unit
step response of various systems by looping through various values of
zeta and nu and saves them as images

INPUTS:
- N/A

OUTPUTS:
- step response images

OUTPUT FOLDER: results/unitStepResponses_img

MODEL TYPE: G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

---
**Source Path:** `C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code\UnitStepResponse_img.m`