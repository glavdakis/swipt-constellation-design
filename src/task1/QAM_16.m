%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M = 16;
dmin=0.63246;
points_per_axis = sqrt(M);
i=linspace((-3/2)*dmin, (3/2)*dmin, points_per_axis);
q=linspace((-3/2)*dmin, (3/2)*dmin, points_per_axis);
[I,Q] = meshgrid(i,q);
i=I(:);
q=Q(:);

figure;
plot(i,q,'x');
grid on;
axis square;
xlim([-2 2])
ylim([-2 2])
title('16-QAM, $d_{\min}=0.6325$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'QAM_16.pdf','ContentType','vector');