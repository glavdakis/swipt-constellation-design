M = 16;
dmin=0.64;
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
title('16-QAM');
xlabel('In-phase');
ylabel('Quadrature');

%saveas(gcf, 'QAM_16.pdf');