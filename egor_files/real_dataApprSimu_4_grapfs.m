close all;

% Получить имя текущего скрипта (без расширения)
scriptName = mfilename;

% Создать папку с именем скрипта, если её нет
if ~exist(scriptName, 'dir')
    mkdir(scriptName);
end

% Исходные данные
files = flip(["data-100", "data-80", "data-60", "data-40", "data-20", ...
              "data20", "data40", "data60", "data80", "data100"]);
voltages = flip([-100, -80, -60, -40, -20, 20, 40, 60, 80, 100]);

clr = lines(numel(files));
clr1 = lines(numel(files));

% Создание графиков
figure(1); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('θ, рад', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угла от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(3); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('θ, рад', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угла от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(2); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('ω, рад/с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угловой скорости от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(4); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('ω, рад/с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угловой скорости от времени', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

% Создание графиков только для симуляции
figure(7); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('θ, рад', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угла от времени (Simulink)', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(8); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('ω, рад/с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угловой скорости от времени (Simulink)', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(9); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('θ, рад', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угла от времени (Simulink)', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

figure(10); clf; hold on; grid on;
xlabel('t, c', 'Interpreter', 'none', 'FontSize', 14);
ylabel('ω, рад/с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость угловой скорости от времени (Simulink)', 'Interpreter', 'none', 'FontSize', 14);
set(gca, 'TickLabelInterpreter', 'none', 'FontSize', 12, 'Box', 'on');

Legend = cell(1, numel(files) * 3); % для реальных, аппроксимированных и симулированных данных
Legend1 = cell(1, numel(files) * 3); % для реальных, аппроксимированных и симулированных данных
Legend2 = cell(1, numel(files)); % только для симуляции (первые 5)
Legend3 = cell(1, numel(files)); % только для симуляции (оставшиеся 5)

k_all = [];
Tm_all = [];

thiknes = 1.5;
g = 1;

% Основной цикл для обработки данных
for i = 1:length(files)
    data = readmatrix(files(i));
    U = voltages(i);

    time = data(:, 1);
    angle = data(:, 2) * pi / 180;
    omega = data(:, 3) * pi / 180;

    % Аппроксимация
    par0 = [52, 69];
    fun = @(par, time) U * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par = lsqcurvefit(fun, par0, time, angle);
    k = par(1);
    Tm = par(2);
    k_all = [k_all, k];
    Tm_all = [Tm_all, Tm];

    time_apr = 0:0.01:1;
    theta = U * k * (time_apr - Tm * (1 - exp(-time_apr / Tm)));
    omega1 = U * k * (1 - exp(-time_apr / Tm));

    % Графики с реальными, аппроксимированными и симулированными данными
    if i <= 5
        figure(1);
        plot(time, angle, 'LineWidth', thiknes, 'Color', clr(i, :));
        plot(time_apr, theta, '--', 'LineWidth', thiknes, 'Color', flip(clr1(i, :)));
        
        figure(2);
        plot(time, omega, 'LineWidth', thiknes, 'Color', clr(i, :));
        plot(time_apr, omega1, '--', 'LineWidth', thiknes, 'Color', flip(clr1(i, :)));
        
        Legend{g} = sprintf('U = %d%%', U);
        Legend{g+1} = sprintf('Аппроксимация U = %d%%', U);
    else
        figure(3);
        plot(time, angle, 'LineWidth', thiknes, 'Color', clr(i, :));
        plot(time_apr, theta, '--', 'LineWidth', thiknes, 'Color', flip(clr1(i, :)));
        
        figure(4);
        plot(time, omega, 'LineWidth', thiknes, 'Color', clr(i, :));
        plot(time_apr, omega1, '--', 'LineWidth', thiknes, 'Color', flip(clr1(i, :)));
        
        Legend1{g - length(files)} = sprintf('U = %d%%', U);
        Legend1{(g - length(files)) + 1} = sprintf('Аппроксимация U = %d%%', U);
    end
    g = g + 2;
end

% СИМУЛИНК
result_k = mean(k_all);
result_Tm = mean(Tm_all);

% Второй цикл для симуляции
for i = 1:length(files)
    U_pr = voltages(i);
    out = sim("simu_lab1.slx");
    
    % Графики с реальными, аппроксимированными и симулированными данными
    if i <= 5
        figure(1);
        plot(out.theta.Time, out.theta.Data, ':', 'LineWidth', thiknes, 'Color', clr(i, :));
        
        figure(2);
        plot(out.omega.Time, out.omega.Data, ':', 'LineWidth', thiknes, 'Color', clr(i, :));
        
        Legend{g} = sprintf('Simulink U = %d%%', U_pr);
        
        % Графики только с симуляцией (первые 5)
        figure(7);
        plot(out.theta.Time, out.theta.Data, 'LineWidth', thiknes, 'Color', clr(i, :));
        
        figure(8);
        plot(out.omega.Time, out.omega.Data, 'LineWidth', thiknes, 'Color', clr(i, :));
        
        Legend2{i} = sprintf('U_pr = %d%%', U_pr);
    else
        figure(3);
        plot(out.theta.Time, out.theta.Data, ':', 'LineWidth', thiknes, 'Color', clr(i, :));
        
        figure(4);
        plot(out.omega.Time, out.omega.Data, ':', 'LineWidth', thiknes, 'Color', clr(i, :));
        
        Legend1{(g - length(files)) + 2} = sprintf('Simulink U = %d%%', U_pr);
        
        % Графики только с симуляцией (оставшиеся 5)
        figure(9);
        plot(out.theta.Time, out.theta.Data, 'LineWidth', thiknes, 'Color', clr(i, :));
        
        figure(10);
        plot(out.omega.Time, out.omega.Data, 'LineWidth', thiknes, 'Color', clr(i, :));
        
        Legend3{i - 5} = sprintf('U_pr = %d%%', U_pr);
    end
    g = g + 1;
end

% Удаление пустых элементов из массивов легенд
Legend = Legend(~cellfun('isempty', Legend));
Legend1 = Legend1(~cellfun('isempty', Legend1));
Legend2 = Legend2(~cellfun('isempty', Legend2));
Legend3 = Legend3(~cellfun('isempty', Legend3));

% Добавление легенд
figure(1);
xlim([0 1]);
legend(Legend, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(2);
xlim([0 1]);
legend(Legend, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(3);
xlim([0 1]);
legend(Legend1, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(4);
xlim([0 1]);
legend(Legend1, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(7);
xlim([0 1]);
legend(Legend2, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(8);
xlim([0 1]);
legend(Legend2, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(9);
xlim([0 1]);
legend(Legend3, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

figure(10);
xlim([0 1]);
legend(Legend3, 'Interpreter', 'none', 'Location', 'best', 'FontSize', 10);

% Сохранение графиков
figures = findobj('Type', 'figure'); % Найти все открытые фигуры
for i = 1:numel(figures)
    figure(figures(i)); % Активировать фигуру
    set(gcf, 'Position', [100, 100, 800, 400]); % Установить размер окна
    
    % Настройка легенды справа
    legend('Location', 'eastoutside');
    
    % Убрать лишние отступы
    set(gca, 'LooseInset', get(gca, 'TightInset'));
    
    % Сохранить в папку
    saveas(gcf, fullfile(scriptName, sprintf('Figure_%d.svg', figures(i).Number)));
end