nu = 1.3;
zeta = 1.8;
wn = 1;
u = @(s) 1./s;
G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

tfinal = 30; % Reduzido para 30s uma vez que já não precisamos de esperar pela cauda longa (t95 e t99)
[t, y] = invFourierTrapz(G, u, tfinal, 0.01);

% --- Extração Direta por Índices (Sem t95 e t99) ---
t01 = t(find(y >= 0.1, 1));
t02 = t(find(y >= 0.2, 1));
t05 = t(find(y >= 0.5, 1));
t07 = t(find(y >= 0.7, 1));
t08 = t(find(y >= 0.8, 1));
t09 = t(find(y >= 0.9, 1));

% Chamar a tua função apenas para extrair as variáveis do Pico (Mp e tp)
[tau1, tau2, tau3, tau4, tau5, tp, Mp, t05] = extractPoints_final(nu, zeta, wn);

% --- Configuração do Gráfico ---
h = zeros(8, 1);
figure

% Curva de Resposta ao Degrau
h(1) = plot(t, y, 'LineWidth', 1.5, 'DisplayName', 'Step Resp. Curve');
hold on

% Plot dos tempos de transição necessários
h(2) = plot(t01, 0.1, 'mo', 'MarkerFaceColor', 'm', 'DisplayName', 't_{0.1}');
h(3) = plot(t02, 0.2, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 't_{0.2}');
h(4) = plot(t05, 0.5, 'rx', 'MarkerFaceColor', 'm', 'DisplayName', 't_{0.5}');
h(5) = plot(t07, 0.7, 'co', 'MarkerFaceColor', 'c', 'DisplayName', 't_{0.7}');
h(6) = plot(t08, 0.8, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 't_{0.8}');
h(7) = plot(t09, 0.9, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 't_{0.9}');

% Lógica de inclusão do Pico na Legenda
if Mp > 0
    h(8) = plot(tp, Mp + 1, 'b^', 'MarkerFaceColor', 'b', 'MarkerSize', 8, 'DisplayName', 'M_p');
    legend_elements = h;
else
    legend_elements = h(1:7); % Se não há pico, esconde o handle vazio da legenda
end

% Linha de Regime Estacionário
yline(1, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1, 'DisplayName', 'SS value')

% Detalhes estéticos do gráfico
title(sprintf('Step Response and Interest Points (\\nu = %.1f, \\zeta = %.1f)', nu, zeta))
xlabel('Time (s)')
ylabel('Amplitude')
legend(legend_elements, 'Location', 'southeast')
axis([0 tfinal 0 1.3])
grid on

%% Functions

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