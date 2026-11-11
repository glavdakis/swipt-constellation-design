N=4;  
M=16;
n=M/N;
dmin=0.627;
radii=[dmin/sqrt(2) dmin*((1+sqrt(3))/2) dmin*((sqrt(2)+2)/2) ...
    4-5.280239*dmin.^2]; 
phaseOffsets = [pi/4, 0, pi/4, 0];  
cqam_points = [];

%print symbols
for i = 1:N
    theta = linspace(0, 2*pi, n+1);
    theta = theta + phaseOffsets(i); 
    circle_points = radii(i).*exp(1j * theta);
    cqam_points = [cqam_points; circle_points.']; 
end

figure;
xlim([-3 3])
ylim([-3 3])
grid on;
title('16-CQAM, N=4 for max d_{min} ');
xlabel('In-phase');
ylabel('Quadrature');
axis square;

%print R_{1} circle
center = [0, 0]; 
viscircles(center, radii(1),'Color','b'); 
hold on

%print R_{2} to R_{N-1}  circle
for i = 2:N-1
  viscircles(center, radii(i),'Color','b'); 
end

%print R_{N} circle
viscircles(center, radii(4),'Color','r');

plot(real(cqam_points), imag(cqam_points), 'o','MarkerFaceColor','b');
hold off

%saveas(gcf,'CQAM_16_N4_dmin.pdf');

