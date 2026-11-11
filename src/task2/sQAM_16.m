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
plot(i,q,'x');
grid on;
axis square;
xlim([-2 2])
ylim([-2 2])
title('16-sQAM, PAPR=3.214, d_{min}=0.378');
xlabel('In-phase');
ylabel('Quadrature');

%saveas(gcf, 'sQAM_16.pdf');