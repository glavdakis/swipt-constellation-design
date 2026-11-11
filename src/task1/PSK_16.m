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
title('16-PSK');
xlabel('In-phase');
ylabel('Quadrature');

%saveas(gcf,'PSK_16.pdf');