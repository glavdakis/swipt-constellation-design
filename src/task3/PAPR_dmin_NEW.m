%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%16-QAM
c=15.44016936;
dmin_i=linspace(0,0.5332255829,200);
PAPR_i=16-3*c*dmin_i.^2;
plot(dmin_i,PAPR_i,"g")
hold on

%16-CQAM, N=4
dmin_ii=linspace(0,sqrt(2/(3+sqrt(3))),200);
PAPR_ii=4-(3.5+sqrt(3))*dmin_ii.^2;
plot(dmin_ii,PAPR_ii,"r")

%16-CQAM, N=8
dmin_iii=linspace(0,2/3,200);
PAPR_iii=8-13.25*dmin_iii.^2;
plot(dmin_iii,PAPR_iii,"c")

%16-sQAM, 4 symbols spike
dmin_iv=linspace(0,0.63245,200);
PAPR_iv=4-5.5*dmin_iv.^2;
plot(dmin_iv,PAPR_iv,"b")

%16-sQAM, 1 symbol spike
dmin_v=linspace(0,0.63246,200);
PAPR_v=16-35.5*dmin_v.^2;
plot(dmin_v,PAPR_v,"m")


xlim([0 0.7])
ylim([0 17])
xlabel('$d_{\min}$');
ylabel('PAPR');
title('PAPR versus $d_{\min}$');
legend({'Proposed 16-QAM, $N=5$','16-CQAM, $N=4$','16-CQAM, $N=8$',...
    '16-sQAM, $i=4$','16-sQAM, $i=1$'},'Location','northeast');
grid on;
hold off
   
%exportgraphics(gcf,'PAPR_dmin_NEW.pdf','ContentType','vector');
