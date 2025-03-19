clear all;
files = ["data-100", "data-80", "data-60", "data-40", "data-20", "data20", "data40", "data60","data80","data100"]
voltages = [-100, -80, -60, -40, -20, 20, 40, 60, 80, 100];
k_all = [];
Tm_all = [];
for i=1:10
    data = readmatrix(files(i));
    U = voltages(i);
    time = data(1:130,1);
    size(time)
    %cut_time = time(:,1,1);
    angle = data(1:130,2)*pi/180;
    omega = data(1:130,3)*pi/180;
    figure(1)
    set(gcf, "Name", "реальные данные")
    plot(time, angle)
    xlabel("time, s")
    ylabel("angle, rad")
    hold on
    figure(2)
    set(gcf, "Name", "реальные данные")
    plot(time, omega)
    xlabel("time, s")
    ylabel("omega, rad")
    hold on
    % approximation
    par0 = [52, 69];
    fun = @(par,time) U*par(1)*(time - par(2)*(1 - exp(-time/par(2))));
    par = lsqcurvefit(fun,par0,time,angle)
    k = par(1);
    k_all = [k_all, k];
    Tm = par(2);
    Tm_all = [Tm_all, Tm];
    time_apr = 0:0.01:1;

    theta = U*k*(time_apr - Tm*(1 - exp(-time_apr/Tm)));
    figure(1)
    plot(time_apr,theta)
    hold on

    omega1 = U*k*(1-exp(-time_apr/Tm));
    figure(2)
    plot(time_apr,omega1)
    hold on
end

result_k = mean(k_all);
result_Tm = mean(Tm_all);

for i=1:10
    U_pr = voltages(i);
    out = sim("simu_lab1.slx");
    figure(3)
    set(gcf, "Name", "симулинк")
    plot(out.omega.Time, out.omega.Data)
    xlabel("t, сек")
    ylabel("omega, рад/с")
    hold on

    figure(4)
    set(gcf, "Name", "симулинк")
    plot(out.theta.Time, out.theta.Data)
    xlabel("t, сек")
    ylabel("thetas, рад/с")
    hold on
end


