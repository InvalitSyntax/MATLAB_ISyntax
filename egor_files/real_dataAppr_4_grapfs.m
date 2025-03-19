
close all;
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

Legend = cell(1, numel(files)); % для аппроксимации увеличиваем размер
Legend1 = cell(1, numel(files)); % для аппроксимации

k_all = [];
Tm_all = [];

thiknes = 1.5;
g = 1;

for i = 1:length(files)
    data = readmatrix(files(i));
    U = voltages(i);

    time = data(:,1);
    angle = data(:,2) * pi/180;
    omega = data(:,3) * pi/180;

    % approximation
    par0 = [52, 69];
    fun = @(par,time) U*par(1)*(time - par(2)*(1 - exp(-time/par(2))));
    par = lsqcurvefit(fun,par0,time,angle);
    k = par(1);
    Tm = par(2);
    k_all = [k_all, k];
    Tm_all = [Tm_all, Tm];

    time_apr = 0:0.01:1;
    theta = U*k*(time_apr - Tm*(1 - exp(-time_apr/Tm)));
    omega1 = U * k *(1 - exp ( - time_apr / Tm ) ) ;

    if i<=5
        figure(1);
        plot(time, angle, 'LineWidth', thiknes, 'Color', clr(i,:));
        plot ( time_apr , theta , '--', 'LineWidth', thiknes , 'Color', flip(clr1 (i ,:)) ) ;
    
        figure(2);
        plot(time, omega, 'LineWidth', thiknes, 'Color', clr(i,:));
        plot ( time_apr , omega1 , '--', 'LineWidth', thiknes , 'Color', flip(clr1 (i ,:)) ) ;
    
        Legend{g} = sprintf('U = %d%%', U);
        Legend{g+1} = sprintf('Аппроксимация U = %d%%', U);

    else
        figure(3);
        plot(time, angle, 'LineWidth', thiknes, 'Color', clr(i,:));
        plot ( time_apr , theta , '--', 'LineWidth', thiknes , 'Color', flip(clr1 (i ,:)) ) ;
    
        figure(4);
        plot(time, omega, 'LineWidth', thiknes, 'Color', clr(i,:));
        plot ( time_apr , omega1 , '--', 'LineWidth', thiknes , 'Color', flip(clr1 (i ,:)) ) ;
   
        % disp(g)
        Legend1{g - length(files)} = sprintf('U = %d%%', U);
        Legend1{(g - length(files)) + 1} = sprintf('Аппроксимация U = %d%%', U);
    end
    g = g + 2;
    
end

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