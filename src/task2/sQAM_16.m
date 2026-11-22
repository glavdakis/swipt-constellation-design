%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;
dmin=0.378;
points_per_axis = sqrt(M);
i=linspace((-3/2)*dmin, (3/2)*dmin, points_per_axis);
q=linspace((-3/2)*dmin, (3/2)*dmin, points_per_axis);
[I,Q] = meshgrid(i,q);
i=I(:);
q=Q(:);

%symbols s_{1}, s_{4}, s_{13}, s_{16} further from center
%I-coordinates
i(1)=(-1.2677);
i(4)=(-1.2677);
i(13)=(+1.2677);
i(16)=(+1.2677);

%Q-coordinates
q(1)=(+1.2677);
q(4)=(-1.2677);
q(13)=(-1.2677);
q(16)=(+1.2677);

figure;
plot(i,q,'o','Color',[0 0.447 0.741]);
grid on;
axis square;
xlim([-2 2])
ylim([-2 2])
title('16-sQAM, $i=4$, $d_{\min}=0.378$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'sQAM_16.pdf','ContentType','vector');