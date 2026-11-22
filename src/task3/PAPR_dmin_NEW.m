%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%proposed 16-point constellation: 15 hexagonal-lattice points around their
%centroid + 1 spike; it reaches the upper bound PAPR <= 16 - S15*dmin^2
figure('Position',[100 100 560 560]);
dmin_i=linspace(0,15/(4*sqrt(31)),200);
PAPR_i=16-(464/15)*dmin_i.^2;
plot(dmin_i,PAPR_i,"k","LineWidth",1.2)
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
legend({'Proposed 16-point constellation','16-CQAM, $N=4$','16-CQAM, $N=8$',...
    '16-sQAM, $i=4$','16-sQAM, $i=1$'},'Location','southoutside','NumColumns',2);
grid on;
hold off

%exportgraphics(gcf,'PAPR_dmin_NEW.pdf','ContentType','vector');
