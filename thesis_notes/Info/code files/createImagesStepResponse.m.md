## Description

THESIS PROJECT: Time-Domain Identification of Second-Species Systems
AUTHOR: Rodrigo Fonseca
DATE: 2026
TYPE: SCRIPT
STATUS: FINISHED

PROGRAM DESCRIPTION:
This program uses the databse in [[Database Values] to plot the unit step
response of the various systems.

INPUTS:
- N/A

OUTPUTS:
- step response images

OUTPUT FOLDER: results/unitStepResponses_img

MODEL TYPE: G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

---
**Source Path:** `C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code\createImagesStepResponse.m`