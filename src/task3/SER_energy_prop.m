%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%SER versus harvested energy at very high SNR for the proposed constellation.
%A symbol whose energy is at most ε(x) moves to the origin. If k symbols are
%at the origin, the ML detector cannot tell them apart and decides correctly
%for only one of them, so SER = (k-1)/M.
Es=1;
M=16;
e_x=linspace(0,4.2,4201); %range of ε(x)

%proposed constellation, max dmin (PAPR = 61/31)
dmin_p1=15/(4*sqrt(31));
x_prop1=prop_points(dmin_p1);

%proposed constellation with the same PAPR as 16-sQAM, i=4 (PAPR = 3.214)
dmin_p2=sqrt((16-3.214)/(464/15));
x_prop2=prop_points(dmin_p2);

%16-QAM
d=sqrt(2/5);
[I,Q]=meshgrid((-1.5:1:1.5)*d);
x_qam=I(:)+1j*Q(:);

%16-CQAM, N=4, max dmin
dmin_c=0.65012;
R=[dmin_c/sqrt(2) dmin_c*((1+sqrt(3))/2) dmin_c*sqrt(2+sqrt(3)/2) ...
    sqrt(4-(3.5+sqrt(3))*dmin_c^2)];
ph=[pi/4, 0, atan(sqrt(3)-1), atan(1+2/sqrt(3))];
x_cqam=reshape(R.*exp(1j*(ph+2*pi*(0:3)'/4)),[],1);

%16-sQAM, i=4 spiked symbols
dmin_s=0.378;
[I,Q]=meshgrid((-1.5:1:1.5)*dmin_s);
x_sqam=I(:)+1j*Q(:);
corner=abs(abs(real(x_sqam))-1.5*dmin_s)<1e-9 & abs(abs(imag(x_sqam))-1.5*dmin_s)<1e-9;
x_sqam(corner)=sqrt((4-5.5*dmin_s^2)/2)*(sign(real(x_sqam(corner)))+1j*sign(imag(x_sqam(corner))));

ser=@(x) max(sum(abs(x(:)).^2<=e_x,1)-1,0)/M; %SER for every value of ε(x)

sets={x_prop1,'k'; x_prop2,'m'; x_qam,'b'; x_cqam,'r'; x_sqam,[0 0.6 0]};
figure;
hold on
for s=1:size(sets,1)
    hl(s)=plot(e_x, ser(sets{s,1}), '-', 'Color', sets{s,2}, 'LineWidth', 1);
end

%% simulation: Monte Carlo with ML detection at very high SNR (Eb/N0 = 60 dB)
rng(1);
EbN0=10^(60/10);
sigma=sqrt(1/(4*EbN0)/2); %Es=4Eb=1
e_sim=0:0.1:4.2;
Nsym=2e4;
for s=1:size(sets,1)
    ser_sim=sim_ser(sets{s,1},e_sim,sigma,Nsym);
    plot(e_sim,ser_sim,'o','Color',sets{s,2},'MarkerSize',4);
end
hs=plot(nan,nan,'ko','MarkerSize',4); %legend entry for the simulation markers

xlim([0 4.2])
ylim([0 1])
xlabel('Harvested energy $\varepsilon(x)$');
ylabel('SER');
title('SER versus $\varepsilon(x)$, proposed constellation');
legend([hl hs],{'Proposed, max $d_{\min}$','Proposed, PAPR $=3.214$','16-QAM',...
    '16-CQAM, $N=4$, max $d_{\min}$','16-sQAM, $i=4$','simulation'},'Location','southeast');
grid on;
box on;
hold off

%exportgraphics(gcf,'SER_energy_prop.pdf','ContentType','vector');

function points=prop_points(dmin)
%proposed 16-point constellation with minimum distance dmin and Es=1:
%15 hexagonal-lattice points around their centroid + 1 spike
M=16;
ab=[0 0; 0 1; 1 0; -1 1; 1 -1; -1 0; 0 -1; 1 1; -1 2; 0 2; 2 -1; 2 0; -2 1; -2 2; 1 -2];
c=7/30+1j*sqrt(3)/6; %centroid of the 15 lattice points
x=dmin*((ab(:,1)+ab(:,2)/2)+1j*sqrt(3)/2*ab(:,2)-c);
u=(-1-1/2)+1j*(-sqrt(3)/2)-c; %direction of the lattice point (a,b)=(-1,-1)
points=[x; sqrt(M-sum(abs(x).^2))*u/abs(u)];
end

function ser=sim_ser(x,e_grid,sigma,Nsym)
%Monte Carlo SER after harvesting energy e from every symbol (ML detection;
%symbols at the same position are decided as the first of them)
ser=zeros(size(e_grid));
for k=1:numel(e_grid)
    r=abs(x);
    y=x.*sqrt(max(r.^2-e_grid(k),0))./max(r,eps); %symbols after harvesting
    tx=randi(numel(y),Nsym,1);
    noise=sigma*(randn(Nsym,1)+1j*randn(Nsym,1));
    [~,rx]=min(abs(y(tx)+noise-y.'),[],2);
    ser(k)=mean(rx~=tx);
end
end
