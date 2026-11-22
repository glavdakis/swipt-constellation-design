%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;
Es=1;
i=linspace(1,M+1,17);
theta =(i-1)*2*pi/M;
I=Es*cos(theta);
Q=Es*sin(theta);

figure;
plot(I,Q,'-x');
grid on;
axis square;
xlim([-2 2])
ylim([-2 2])
title('16-PSK, $d_{\min}=0.3902$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'PSK_16.pdf','ContentType','vector');