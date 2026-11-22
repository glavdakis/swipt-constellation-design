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
    theta = (0:n-1)*2*pi/n; %n symbols, equally spaced
    theta = theta + phaseOffsets(i); 
    circle_points = radii(i).*exp(1j * theta);
    cqam_points = [cqam_points; circle_points.']; 
end

figure;
xlim([-2.5 2.5])
ylim([-2.5 2.5])
grid on;
title('16-CQAM, $N=8$, $d_{\min}=0.405$');
xlabel('In-phase');
ylabel('Quadrature');
axis square;

blue=[0 0.447 0.741]; %MATLAB default blue, as in [R1]
t=linspace(0,2*pi,400);
hold on
%circles R_1,...,R_{N-1} in blue and R_N in red
for i = 1:N-1
    plot(radii(i)*cos(t), radii(i)*sin(t), 'Color', blue);
end
plot(radii(N)*cos(t), radii(N)*sin(t), 'r');
plot(real(cqam_points), imag(cqam_points), 'o', 'Color', blue);
hold off

%exportgraphics(gcf,'CQAM_16_N8.pdf','ContentType','vector');