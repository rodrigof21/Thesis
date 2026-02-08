## Description

THESIS PROJECT: Time-Domain Identification of Second-Species Systems
AUTHOR: Rodrigo Fonseca
DATE: 2026
TYPE: SCRIPT
STATUS: IN PROGRESS

PROGRAM DESCRIPTION:
This Program plots the Bode diagram of various transfer functions with
different values for nu, zeta and wn.

INPUTS:
- nu_vec:   Vector of base fractional orders (e.g., [0.2, 0.5, 0.8]).
- zeta_vec: Vector of damping ratios (e.g., [0.3, 0.7, 1.2]).
- wn_vec:   Vector of natural frequencies in rad/s (e.g., [1, 5, 10]).

OUTPUTS:
- Graphical: Bode plots for each parameter combination.
- Files:     PNG images saved to the 'Bode_Plots_Thesis' directory.

OUTPUT FOLDER: /results/bode

MODEL STRUCTURE: G(s) = wn^2 / (s^(nu+1) + 2*zeta*wn*s^nu + wn^2)

---
**Source Path:** `C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code\bode.m`