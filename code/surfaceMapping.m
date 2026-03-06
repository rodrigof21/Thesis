%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Plots nu = f(t02, t08) and zeta = f(t05, nu)
%
% OUTPUT FOLDER: results/surfaceMapping
%==========================================================================


outputFolder = 'results/surfaceMapping';
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\validatedPoints\double_validated_points.mat')

sys = fieldnames(validated_results);
Mp  = cellfun(@(s) validated_results.(s).Mp_rel, sys);
t02_data = cellfun(@(s) validated_results.(s).t02, sys);
t05_data = cellfun(@(s) validated_results.(s).t05, sys);
t08_data = cellfun(@(s) validated_results.(s).t08, sys);
nu_data  = cellfun(@(s) validated_results.(s).nu, sys);
zeta_data = cellfun(@(s) validated_results.(s).zeta, sys);

results = [Mp, t02, t05, t08, nu, zeta];

t02_data  = results(:, 2);
t05_data  = results(:, 3);
t08_data  = results(:, 4);
nu_data   = results(:, 5);
zeta_data = results(:, 6);

% --- SURFACE PLOT 1: nu = f(t02, t08) ---
h_surf1 = figure('Name', 'Surface nu = f(t02, t08)', 'Color', 'w');
% Criar triangulação para dados dispersos
tri1 = delaunay(t02_data, t08_data);
trisurf(tri1, t02_data, t08_data, nu_data, 'FaceAlpha', 0.8, 'EdgeColor', 'none');

hold on;
scatter3(t02_data, t08_data, nu_data, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.5);

title('Mapping: \nu = f(t_{0.2}, t_{0.8})');
xlabel('Rise Time t_{0.2} (s)');
ylabel('Rise Time t_{0.8} (s)');
zlabel('Fractional Order \nu');
colorbar; colormap jet; view(45, 30); grid on;
saveas(h_surf1, fullfile(outputFolder, 'surface_nu_t02_t08'));

% --- SURFACE PLOT 2: zeta = f(t05, nu) ---
h_surf2 = figure('Name', 'Surface zeta = f(t05, nu)', 'Color', 'w');
% Criar triangulação
tri2 = delaunay(t05_data, nu_data);
trisurf(tri2, t05_data, nu_data, zeta_data, 'FaceAlpha', 0.8, 'EdgeColor', 'none');

hold on;
scatter3(t05_data, nu_data, zeta_data, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.5);

title('Mapping: \zeta = f(t_{0.5}, \nu)');
xlabel('Rise Time t_{0.5} (s)');
ylabel('Fractional Order \nu');
zlabel('Damping \zeta');
colorbar; colormap jet; view(-135, 25); grid on;
saveas(h_surf2, fullfile(outputFolder, 'surface_zeta_t05_nu'));