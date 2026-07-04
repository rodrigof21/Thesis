% load data
load("C:\Users\r7fon\OneDrive - Universidade de Lisboa\MEMec\Thesis\code\ControlDesign\PSO\results\PSO_data_withTf.mat")
nu_raw   = PSO_data(:, 1);
zeta_raw = PSO_data(:, 2);


nu_unicos   = unique(round(nu_raw, 3));
zeta_unicos = unique(round(zeta_raw, 3));


zeta_sel = [zeta_unicos(1), zeta_unicos(round(end/2)), zeta_unicos(end)];
nu_sel   = [nu_unicos(1), nu_unicos(round(end/2)), nu_unicos(end)];

Nomes = {'Kp', 'Ki', 'Kd', 'Tf'};
Cores = {'#0072BD', '#D95319', '#EDB120'};

fig1 = figure('Name', 'Parâmetros vs Nu', 'Position', [100, 100, 700, 900]);
for i = 1:4
    subplot(4, 1, i);
    hold on; grid on;
    
    for j = 1:length(zeta_sel)

        idx = abs(zeta_raw - zeta_sel(j)) < 1e-3;
        x_plot = nu_raw(idx);
        y_plot = PSO_data(idx, i+2);
        

        [x_plot, sort_idx] = sort(x_plot);
        y_plot = y_plot(sort_idx);
        

        plot(x_plot, y_plot, '-o', 'LineWidth', 1.5, 'Color', Cores{j}, ...
            'MarkerFaceColor', Cores{j}, 'DisplayName', sprintf('\\zeta = %.2f', zeta_sel(j)));
    end
    
    title(sprintf('Evolução do %s em função da ordem fracionária (\\nu)', Nomes{i}));
    xlabel('\nu');
    ylabel(Nomes{i});
    legend('Location', 'best');
end

fig2 = figure('Name', 'Parâmetros vs Zeta', 'Position', [850, 100, 700, 900]);
for i = 1:4
    subplot(4, 1, i);
    hold on; grid on;
    
    for j = 1:length(nu_sel)

        idx = abs(nu_raw - nu_sel(j)) < 1e-3;
        x_plot = zeta_raw(idx);
        y_plot = PSO_data(idx, i+2);
        

        [x_plot, sort_idx] = sort(x_plot);
        y_plot = y_plot(sort_idx);
        

        plot(x_plot, y_plot, '-s', 'LineWidth', 1.5, 'Color', Cores{j}, ...
            'MarkerFaceColor', Cores{j}, 'DisplayName', sprintf('\\nu = %.2f', nu_sel(j)));
    end
    
    title(sprintf('Evolução do %s em função do amortecimento (\\zeta)', Nomes{i}));
    xlabel('\zeta');
    ylabel(Nomes{i});
    legend('Location', 'best');
end