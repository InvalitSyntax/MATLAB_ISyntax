
close all;
files = ["data-100", "data-80", "data-60", "data-40", "data-20", "data20", "data40", "data60", "data80", "data100"];
voltages = [-100, -80, -60, -40, -20, 20, 40, 60, 80, 100];
k_all = [];
Tm_all = [];
w_all = [];

% Цвета для графиков
clr = lines(numel(files));

% Основной цикл для обработки данных
for i = 1:numel(files)
    data = readmatrix(files(i));
    U = voltages(i);
    time = data(1:130, 1);
    angle = data(1:130, 2) * pi / 180;
    omega = data(1:130, 3) * pi / 180;

    % Аппроксимация
    par0 = [52, 69];
    fun = @(par, time) U * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par = lsqcurvefit(fun, par0, time, angle);
    k = par(1);
    Tm = par(2);
    w_str = U * k;

    % Сохранение результатов
    k_all = [k_all, k];
    Tm_all = [Tm_all, Tm];
    w_all = [w_all, w_str];
end

% График зависимости Tm от voltages
figure(1); clf; hold on; grid on;
plot(voltages, Tm_all, 'o-', 'LineWidth', 3, 'Color', clr(1, :));
xlabel('Напряжение, %', 'Interpreter', 'none', 'FontSize', 14);
ylabel('T_m, с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость T_m от напряжения', 'Interpreter', 'none', 'FontSize', 16);
set(gca, 'FontSize', 12, 'Box', 'on');

% График зависимости w_уст от voltages
figure(2); clf; hold on; grid on;
plot(voltages, w_all, 'o-', 'LineWidth', 3, 'Color', clr(2, :));
xlabel('Напряжение, %', 'Interpreter', 'none', 'FontSize', 14);
ylabel('ω_{уст}, рад/с', 'Interpreter', 'none', 'FontSize', 14);
title('Зависимость w_{уст} от напряжения', 'Interpreter', 'none', 'FontSize', 16);
set(gca, 'FontSize', 12, 'Box', 'on');

% Вывод средних значений
fprintf('Среднее значение k: %.2f\n', mean(k_all));
fprintf('Среднее значение T_m: %.2f\n', mean(Tm_all));