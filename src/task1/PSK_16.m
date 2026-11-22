%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;
Es=1;
i=1:M;
theta =(i-1)*2*pi/M;
I=sqrt(Es)*cos(theta);
Q=sqrt(Es)*sin(theta);

figure;
hold on
%the only energy level (also the outer one): red circle, as in [R1]
t=linspace(0,2*pi,400);
plot(sqrt(Es)*cos(t),sqrt(Es)*sin(t),'r');
plot(I,Q,'o','Color',[0 0.447 0.741]);
hold off
grid on;
axis square;
xlim([-2 2])
ylim([-2 2])
title('16-PSK, $d_{\min}=0.3902$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'PSK_16.pdf','ContentType','vector');