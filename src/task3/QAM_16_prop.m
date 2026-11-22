%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%Proposed (optimal) 16-point constellation for the PAPR-dmin trade-off:
%15 symbols on the hexagonal lattice with spacing dmin, as close as possible to
%their centroid (minimum energy), and 1 spike that takes the rest of the energy.
M=16;
dmin=0.6;

%lattice points dmin*((a+b/2) + j*sqrt(3)/2*b), shifted so that their centroid is 0
ab=[0 0; 0 1; 1 0; -1 1; 1 -1; -1 0; 0 -1; 1 1; -1 2; 0 2; 2 -1; 2 0; -2 1; -2 2; 1 -2];
c=7/30+1j*sqrt(3)/6; %centroid of these 15 lattice points
x=dmin*((ab(:,1)+ab(:,2)/2)+1j*sqrt(3)/2*ab(:,2)-c);

%spike: in the direction of the next lattice point (a,b)=(-1,-1), with Es=1
u=(-1-1/2)+1j*(-sqrt(3)/2)-c;
rs=sqrt(M-sum(abs(x).^2));
x16=rs*u/abs(u);
points=[x; x16];

D=abs(points-points.');
D(logical(eye(M)))=inf;
fprintf('Es = %.4f, dmin = %.4f, PAPR = %.4f\n', mean(abs(points).^2), min(D(:)), ...
    max(abs(points).^2)/mean(abs(points).^2));

figure;
blue=[0 0.447 0.741]; %MATLAB default blue, as in [R1]
t=linspace(0,2*pi,400);
hold on
plot(rs*cos(t), rs*sin(t), 'r'); %energy level of the spike
plot(real(points), imag(points), 'o', 'Color', blue);
hold off
grid on;
axis square;
xlim([-2.5 2.5])
ylim([-2.5 2.5])
title('Proposed 16-point constellation, $d_{\min}=0.6$');
xlabel('In-phase');
ylabel('Quadrature');

%exportgraphics(gcf,'QAM_16_prop.pdf','ContentType','vector');
