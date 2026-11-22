%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

N=5;  
M=16;
n=3;
c=15.44016936;
dmin=0.53;
radii=[dmin/sqrt(3) 2*sqrt(3)*dmin/3 ((sqrt(3)+3)/3)*dmin ((2*sqrt(3)+3)/3)*dmin ...
    ((sqrt(3)+6)/3)*dmin]; 
phaseOffsets = [pi/3, 0, pi/3, 0, pi/3]; 
qam_points = [];

%print symbols
for i = 1:N
    theta = (0:n-1)*2*pi/n; %n symbols, equally spaced
    theta = theta + phaseOffsets(i); 
    circle_points = radii(i).*exp(1j * theta);
    qam_points = [qam_points; circle_points.']; 
end

figure;
xlim([-2 2])
ylim([-2 2])
grid on;
title('Proposed 16-QAM, $N=5$, $d_{\min}=0.53$');
xlabel('In-phase');
ylabel('Quadrature');
axis square;

blue=[0 0.447 0.741]; %MATLAB default blue, as in [R1]
t=linspace(0,2*pi,400);
hold on
%circles R_1,...,R_N in blue
for i = 1:N
    plot(radii(i)*cos(t), radii(i)*sin(t), 'Color', blue);
end
%extra symbol s_16 on the outer energy level (red circle)
x=sqrt(16-3*c*dmin.^2);
plot(x*cos(t), x*sin(t), 'r');
plot([real(qam_points); x], [imag(qam_points); 0], 'o', 'Color', blue);
hold off

%exportgraphics(gcf,'QAM_16_NEW.pdf','ContentType','vector');