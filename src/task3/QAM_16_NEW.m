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
    theta = linspace(0, 2*pi, n+1);
    theta = theta + phaseOffsets(i); 
    circle_points = radii(i).*exp(1j * theta);
    qam_points = [qam_points; circle_points.']; 
end

figure;
xlim([-3 3])
ylim([-3 3])
grid on;
title('Proposed 16-QAM, $N=5$, $d_{\min}=0.53$');
xlabel('In-phase');
ylabel('Quadrature');
axis square;

%print R_{1} circle
center = [0, 0]; 
viscircles(center, radii(1),'Color','b'); 
hold on

%print R_{2} to R_{N-1}  circle
for i = 2:N
   center = [0, 0]; 
   viscircles(center, radii(i),'Color','b'); 
end

%extra symbol
x=sqrt(16-3*c*dmin.^2);
scatter(x,0,'red',"filled")

plot(real(qam_points), imag(qam_points), 'o','MarkerFaceColor','b');
hold off

%exportgraphics(gcf,'QAM_16_NEW.pdf','ContentType','vector');