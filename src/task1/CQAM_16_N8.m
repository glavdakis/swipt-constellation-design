%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

N=8;  
M=16;
n=M/N;
dmin=0.405;
%all symbols on the hexagonal lattice with spacing dmin [R3]
radii=[dmin/2 sqrt(3)*dmin/2 sqrt(7)*dmin/2 sqrt(7)*dmin/2 3*dmin/2 ...
    sqrt(13)*dmin/2 sqrt(13)*dmin/2 sqrt(8-13.25*dmin.^2)]; 
phaseOffsets = [pi/2, 0, atan(2/sqrt(3)), pi-atan(2/sqrt(3)), pi/2, ...
    atan(1/(2*sqrt(3))), pi-atan(1/(2*sqrt(3))), atan(4/sqrt(3))]; 
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
title('16-CQAM, $N=8$, $d_{\min}=0.405$');
xlabel('In-phase');
ylabel('Quadrature');
axis square;

%print R_{1} circle
center = [0, 0]; 
viscircles(center, radii(1),'Color','b'); 
hold on

%print R_{2} to R_{N-1}  circle
for i = 2:N-1
   center = [0, 0]; 
   viscircles(center, radii(i),'Color','b'); 
end

%print R_{N} circle
viscircles(center, radii(8),'Color','r');

plot(real(cqam_points), imag(cqam_points), 'o','MarkerFaceColor','b');
hold off

%exportgraphics(gcf,'CQAM_16_N8.pdf','ContentType','vector');