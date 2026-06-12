% filteredPoints (better alternative to results)
load('C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\results\filterPoints\filteredPoints.mat')
results = filteredPoints;

% points data
t02  = results(:, 1);
t05  = results(:, 2);
t08  = results(:, 3);
nu   = results(:, 4);
zeta = results(:, 5);
t07  = results(:, 6);
Mp   = results(:, 7);
tp   = results(:, 8);
t01  = results(:, 9);
t09 = results(:, 10);



% Zeta quando há pico

idx_pico = nu > 0.6 & Mp > 10e-5;
tau1 = (t07./tp);
tau2 = (t08-t05)./(t05-t02);

X_zeta_p = [log(tau1(idx_pico)),(tau2(idx_pico))];
[fit_zeta_p, gof_zeta_p] = fit(X_zeta_p, zeta(idx_pico), 'poly44');
fprintf('R-squared para Zeta_p: %.4f\n', gof_zeta_p.rsquare);


% Zeta sem pico

idx_npico = nu > 0.6 & Mp <= 10e-5;
tau3 = (t01./t05);
tau4 = t08./t02;

X_zeta_n = [log(tau3(idx_npico)),(tau4(idx_npico))];
[fit_zeta_n, gof_zeta_n] = fit(X_zeta_n, zeta(idx_npico), 'poly44');
fprintf('R-squared para Zeta_n: %.4f\n', gof_zeta_n.rsquare);



% nu para zeta => 2

idx1 = nu > 0.6 & zeta >=2;
tau5 = t05./t09;

X_nu_1 = [tau5(idx1), tau3(idx1)];
[fit_nu_1, gof_nu_1] = fit(X_nu_1, nu(idx1), 'poly22');
fprintf('R-squared para nu_1: %.4f\n', gof_nu_1.rsquare);



% nu para zeta < 2

idx2 = nu > 0.6 & zeta < 2;

X_nu_2 = [tau5(idx2), zeta(idx2)];
[fit_nu_2, gof_nu_2] = fit(X_nu_2, nu(idx2), 'poly32');
fprintf('R-squared para nu_2: %.4f\n', gof_nu_2.rsquare);


idModel_final = struct();
idModel_final.peak = fit_zeta_p;
idModel_final.npeak = fit_zeta_n;
idModel_final.nu_1 = fit_nu_1;
idModel_final.nu_2 = fit_nu_2;

% --- save ---
savePath = 'C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final';

if ~exist(fileparts(savePath), 'dir')
    mkdir(fileparts(savePath));
end

save(savePath, 'idModel_final');
fprintf('Modelo idModel_final gravado com sucesso em: %s\n', savePath);


%% GEMINI CODE FOR GRAPHS

% =========================================================================
% PLOTTING THE IDENTIFICATION SURFACES (ALTO CONTRASTE)
% =========================================================================
close all;

% --- 1. Surface for Damping Ratio (Zeta) WITH Peak ---
figure('Name', 'Identification Surface: Zeta (With Peak)', 'Color', 'w', 'Position', [100, 100, 800, 600]);
h1 = plot(fit_zeta_p, X_zeta_p, zeta(idx_pico));

% Estética de Alto Contraste
h1(1).FaceAlpha = 0.85;          % Superfície 15% transparente
h1(1).EdgeColor = [0.4 0.4 0.4]; % Linhas da malha a cinza suave
h1(2).Marker = '.';              
h1(2).MarkerFaceColor = 'k';     
h1(2).MarkerEdgeColor = 'k';      % Contorno preto
h1(2).MarkerSize = 6;            % Aumentar tamanho dos pontos

colormap turbo; %colorbar;        % Ativar gradiente vibrante e barra de cor
title('Identification Surface: Damping Ratio (\zeta) - With Overshoot');
xlabel('ln(\tau_1)');
ylabel('\tau_2');
zlabel('\zeta');
% LEGENDA CORRIGIDA: Apontar explicitamente para os pontos h(2) e superfície h(1)
legend([h1(2), h1(1)], {'Validation Data', 'Fitted Surface'}, 'Location', 'best');
grid on; view(-45, 30);


% --- 2. Surface for Damping Ratio (Zeta) WITHOUT Peak ---
figure('Name', 'Identification Surface: Zeta (No Peak)', 'Color', 'w', 'Position', [150, 150, 800, 600]);
h2 = plot(fit_zeta_n, X_zeta_n, zeta(idx_npico));

h2(1).FaceAlpha = 0.85;          
h2(1).EdgeColor = [0.4 0.4 0.4]; 
h2(2).Marker = '.';              
h2(2).MarkerFaceColor = 'k';     
h2(2).MarkerEdgeColor = 'k';     
h2(2).MarkerSize = 6;            

colormap turbo; %colorbar;
title('Identification Surface: Damping Ratio (\zeta) - No Overshoot');
xlabel('ln(\tau_3)');
ylabel('\tau_4');
zlabel('\zeta');
% LEGENDA CORRIGIDA: Apontar explicitamente para os pontos h(2) e superfície h(1)
legend([h2(2), h2(1)], {'Validation Data', 'Fitted Surface'}, 'Location', 'best');
grid on; view(-45, 30);



% --- 3. Surface for Fractional Order (Nu) when Zeta >= 2 ---
figure('Name', 'Identification Surface: Nu (Zeta >= 2)', 'Color', 'w', 'Position', [200, 200, 800, 600]);
h3 = plot(fit_nu_1, X_nu_1, nu(idx1));

h3(1).FaceAlpha = 0.85;          
h3(1).EdgeColor = [0.4 0.4 0.4]; 
h3(2).Marker = '.';              
h3(2).MarkerFaceColor = 'k';     
h3(2).MarkerEdgeColor = 'k';     
h3(2).MarkerSize = 6;            

colormap turbo; %colorbar;
title('Identification Surface: Fractional Order (\nu) for \zeta \geq 2');
xlabel('\tau_5');
ylabel('\tau_3');
zlabel('\nu');
% LEGENDA CORRIGIDA: Apontar explicitamente para os pontos h(2) e superfície h(1)
legend([h3(2), h3(1)], {'Validation Data', 'Fitted Surface'}, 'Location', 'best');
grid on; view(-45, 30);


% --- 4. Surface for Fractional Order (Nu) when Zeta < 2 ---
figure('Name', 'Identification Surface: Nu (Zeta < 2)', 'Color', 'w', 'Position', [250, 250, 800, 600]);
h4 = plot(fit_nu_2, X_nu_2, nu(idx2));

h4(1).FaceAlpha = 0.85;          
h4(1).EdgeColor = [0.4 0.4 0.4]; 
h4(2).Marker = '.';              
h4(2).MarkerFaceColor = 'k';     
h4(2).MarkerEdgeColor = 'k';    
h4(2).MarkerSize = 6;            

colormap turbo; %colorbar;
title('Identification Surface: Fractional Order (\nu) for \zeta < 2');
xlabel('\tau_5');
ylabel('\zeta');
zlabel('\nu');
% LEGENDA CORRIGIDA: Apontar explicitamente para os pontos h(2) e superfície h(1)
legend([h4(2), h4(1)], {'Validation Data', 'Fitted Surface'}, 'Location', 'best');
grid on; view(-45, 30);