%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%16-PSK
dmin_i=0.3902;
PAPR_i=1;
scatter(dmin_i,PAPR_i,"filled","g","square")
hold on

%16-PAM
dmin_ii=0.2169;
PAPR_ii=2.647;
scatter(dmin_ii,PAPR_ii,"filled","b","^")

%16-QAM
dmin_iii=0.63246;
PAPR_iii=1.8;
scatter(dmin_iii,PAPR_iii,"filled","m","o")

%16-CQAM, N=4
dmin_iv=linspace(0,sqrt(2/(3+sqrt(3))),200);
PAPR_iv=4-(3.5+sqrt(3))*dmin_iv.^2;
plot(dmin_iv,PAPR_iv,"r")

%16-CQAM, N=8
dmin_v=linspace(0,2/3,200);
PAPR_v=8-13.25*dmin_v.^2;
plot(dmin_v,PAPR_v,"c")

xlim([0 0.7])
ylim([0 8])
xlabel('$d_{\min}$');
ylabel('PAPR');
title('PAPR versus $d_{\min}$');
legend({'16-PSK','16-PAM','16-QAM','16-CQAM, $N=4$','16-CQAM, $N=8$'},...
    'Location','northeast');
grid on;
hold off

%exportgraphics(gcf,'PAPR_dmin.pdf','ContentType','vector');
