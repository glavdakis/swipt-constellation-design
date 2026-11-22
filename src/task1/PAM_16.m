%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M = 16;
Eg=3/(M^2-1);
i=linspace(1,M,16);
x=(2*i-M-1)*sqrt(Eg);
y=zeros(size(x));

figure;
plot(x,y,'o','Color',[0 0.447 0.741]);
axis square;
grid on;
xlim([-2 2])
ylim([-2 2])
title('16-PAM, $d_{\min}=0.2169$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'PAM_16.pdf','ContentType','vector');