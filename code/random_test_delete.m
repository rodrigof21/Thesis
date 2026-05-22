% Model

load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\Models\model 2\test_diff_approach\idModel_final.mat")

nu_values = 0.7:0.1:2;

zeta_values = 0.1:0.1:5;

rms = zeros(length(nu_values), length(zeta_values));

err_nu = zeros(length(nu_values), length(zeta_values));

err_zeta = zeros(length(nu_values), length(zeta_values));

total = length(nu_values)*length(zeta_values);

count = 1;

wn = 1;

u = @(s) 1./s;

warning('off', 'signal:findpeaks:largeMinPeakHeight');

for i = 1:length(nu_values)

for j = 1:length(zeta_values)


nu_real = nu_values(i);

zeta_real = zeta_values(j);

stable = checkStability(nu_real, zeta_real);

if ~stable

rms(i,j) = NaN;

fprintf('Unstable\n');

fprintf('%.i/%.i\n', count, total);

count=count+1;

err_nu(i,j) = NaN;

err_zeta(i, j) = NaN;

continue

end


[tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_final(nu_real, zeta_real, wn);


if isnan(tau1) || isnan(tau2) || isnan(tau3) || isnan(tau4) || isnan(tau5) || isnan(t05)

rms(i,j) = NaN;

fprintf('non existing time\n')

fprintf('%.i/%.i\n', count, total);

count=count+1;

err_nu(i,j) = NaN;

err_zeta(i, j) = NaN;

continue

end

% if Mp == 0

% rms(i,j) = inf;

% fprintf('non existing Mp\n')

% fprintf('%.i/%.i\n', count, total);

% count=count+1;

% continue

% end


%ID Logic

if Mp >= 10e-5

model = idModel_final.peak;

zeta_g = model(log(tau1), tau2);

else

model = idModel_final.npeak;

zeta_g = model(log(tau3), tau4);

end


if zeta_g >= 2

model2 = idModel_final.nu_1;

nu_g = model2(tau5, tau3);

else

model2 = idModel_final.nu_2;

nu_g = model2(tau5, zeta_g);

end


% Real Model

G_real = @(s) 1 ./ (1 + 2.*zeta_real.*(s/wn).^nu_real + (s/wn).^(nu_real+1));

[t_real, y_real] = invFourierTrapz(G_real, u, 20, 0.05);

% Guessed Model

G_guess = @(s) 1 ./ (1 + 2.*zeta_g.*(s/wn).^nu_g + (s/wn).^(nu_g+1));

[t_guess, y_guess] = invFourierTrapz(G_guess, u, 20, 0.05);

% Errors

err_nu(i, j) = abs(nu_real - nu_g);

err_zeta(i, j) = abs(zeta_real - zeta_g);

err = y_real-y_guess;

rms(i, j) = sqrt(mean(err.^2));


fprintf('RMS = %.4f\n', rms(i,j))

fprintf('%.i/%.i\n', count, total);

count=count+1;


end

end

warning('on', 'signal:findpeaks:largeMinPeakHeight');

mean_rms = mean(rms(:), 'omitnan');

max_rms = max(rms(:));

mean_nu = mean(err_nu(:), 'omitnan');

max_nu = max(err_nu(:));

mean_zeta = mean(err_zeta(:), 'omitnan');

maz_zeta = max(err_zeta(:));

% --- Print dos Resultados Globais de Erro ---

fprintf('\n===========================================\n');

fprintf(' MÉTRICAS DE ERRO DO MODELO \n');

fprintf('===========================================\n');

fprintf('RMS Médio: %.4f | RMS Máximo: %.4f\n', mean_rms, max_rms);

fprintf('Erro Nu Médio: %.4f | Erro Nu Máximo: %.4f\n', mean_nu, max_nu);

fprintf('Erro Zeta Médio:%.4f | Erro Zeta Máximo:%.4f\n', mean_zeta, maz_zeta);

fprintf('===========================================\n\n');

%% auxiliar functions

function [tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_final(nu_test, zeta_test, wn_test)

G_test = @(s) 1 ./ (1 + 2.*zeta_test.*(s/wn_test).^nu_test + (s/wn_test).^(nu_test+1));

u = @(s) 1./s;

[data.t, data.y] = invFourierTrapz(G_test, u, 60, 0.05);


% Mp tp Overshoot

[pks, locs] = findpeaks(data.y, data.t, 'MinPeakHeight', 1.0001);

if ~isempty(pks) && pks(1) - 1 > 0.05

Mp = pks(1) - 1;

tp = locs(1);

else

Mp = 0;

tp = 0; % Ou o tempo final da simulação

end

t01 = extractTime(data.t, data.y, 0.1);

t02 = extractTime(data.t, data.y, 0.2);

t05 = extractTime(data.t, data.y, 0.5);

t07 = extractTime(data.t, data.y, 0.7);

t08 = extractTime(data.t, data.y, 0.8);

t09 = extractTime(data.t, data.y, 0.9);

tau1 = (t07/tp);

tau2 = (t08-t05)/(t05-t02);

tau3 = (t01/t05);

tau4 = t08/t02;

tau5 = t05/t09;

end

function t_level = extractTime(t, y, level)

% Remove pontos não finitos

valid = isfinite(y) & isfinite(t);

t = t(valid);

y = y(valid);


if isempty(t)

t_level = NaN;

return;

end


idx = find(y >= level, 1);


if isempty(idx) || idx <= 1

t_level = NaN;

return;

end


% Usa janela de 4 pontos para pchip (mais estável)

i0 = max(1, idx-2);

i1 = min(length(y), idx+1);


try

t_level = interp1(y(i0:i1), t(i0:i1), level, 'pchip');

catch

% fallback linear

t_level = interp1(y(idx-1:idx), t(idx-1:idx), level, 'linear');

end

end