files = ["data-100", "data-80", "data-60", "data-40", "data-20", ...
    "data20", "data40", "data60", "data80", "data100"];

voltages = [-100, -80, -60, -40, -20, 20, 40, 60, 80, 100];

clr = parula(numel(files));

% Создание графиков
figure(1); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel(', pqr', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угла от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(2); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel(', pqrc/', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угловой скорости от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

Legend = cell(1, numel(files));

k_all = [];
Tm_all = [];

for i = 1:length(files)
    data = readmatrix(files(i));
    U = voltages(i);

    time = data(:,1);
    angle = data(:,2) * pi/180;
    omega = data(:,3) * pi/180;

    figure(1);
    plot(time, angle, 'LineWidth', 0.5, 'Color', clr(i,:));

    figure(2);
    plot(time, omega, 'LineWidth', 0.5, 'Color', clr(i,:));

    Legend{i} = sprintf('U = %d%%', U);
end

figure(1);
xlim([0 1]);
legend(Legend, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(2);
xlim([0 1]);
legend(Legend, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);