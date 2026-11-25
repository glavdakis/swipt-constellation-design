%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

N=4;  
M=16;
n=M/N;
dmin=0.65012;
%R1, R2 and R3 form equilateral triangles of side dmin (R3 at phase atan(sqrt(3)-1))
radii=[dmin/sqrt(2) dmin*((1+sqrt(3))/2) dmin*sqrt(2+sqrt(3)/2) ...
    sqrt(4-(3.5+sqrt(3))*dmin.^2)]; 
phaseOffsets = [pi/4, 0, atan(sqrt(3)-1), atan(1+2/sqrt(3))];  
cqam_points = [];

%print symbols
for i = 1:N
    theta = (0:n-1)*2*pi/n; %n symbols, equally spaced
    theta = theta + phaseOffsets(i); 
    circle_points = radii(i).*exp(1j * theta);
    cqam_points = [cqam_points; circle_points.']; 
end

figure;
xlim([-2 2])
ylim([-2 2])
grid on;
title('16-CQAM, $N=4$, max $d_{\min}=0.6501$');
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
plot(real(cqam_points), imag(cqam_points), 'o', 'Color', blue, 'MarkerFaceColor', blue);
hold off

%exportgraphics(gcf,'CQAM_16_N4_dmin.pdf','ContentType','vector');

