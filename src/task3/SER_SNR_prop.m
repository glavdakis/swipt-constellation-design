%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%SER versus SNR for the proposed constellation, without energy harvesting and
%with ε(x)=0.2, compared with 16-CQAM (N=4, max dmin) and 16-sQAM (i=4).
%Every curve is the union bound on the actual symbol positions (ML detection).
M=16;
Eb_N0_dB=linspace(0,30); %range of SNR (dB)
Eb_N0=10.^(Eb_N0_dB./10);
N0=1./(4*Eb_N0); %Es=4Eb=1
sigma=sqrt(N0/2); %noise standard deviation per dimension
e_x=0.2; %harvested energy
harvest=@(x,e) x.*sqrt(max(abs(x).^2-e,0))./max(abs(x),eps);

%proposed constellation, max dmin (PAPR = 61/31)
x_prop1=prop_points(15/(4*sqrt(31)));

%proposed constellation with the same PAPR as 16-sQAM, i=4 (PAPR = 3.214)
x_prop2=prop_points(sqrt((16-3.214)/(464/15)));

%16-CQAM, N=4, max dmin
dmin_c=sqrt(2/(3+sqrt(3))); %max dmin of 16-CQAM, N=4 (0.6501)
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

%constellation, color, line style
sets={x_prop1,'k','-'; x_prop2,'m','-'; x_cqam,'r','-'; x_sqam,'g','-';
    harvest(x_prop1,e_x),'k','--'; harvest(x_prop2,e_x),'m','--';
    harvest(x_cqam,e_x),'r','--'; harvest(x_sqam,e_x),'g','--'};

figure('Position',[100 100 560 620]);
SER=zeros(size(sets,1),numel(Eb_N0_dB));
args={};
for s=1:size(sets,1)
    SER(s,:)=ser_nn(sets{s,1},sigma);
    args=[args, {Eb_N0_dB, SER(s,:), [sets{s,2} sets{s,3}]}]; %#ok<AGROW>
end
hl=semilogy(args{:});
hold on

%% simulation: Monte Carlo with ML detection
%symbols at the same position are decided as the first of them
rng(1);
snr_sim=0:2:28;
for s=1:size(sets,1)
    ser_sim=nan(size(snr_sim));
    for k=1:numel(snr_sim)
        %skip points below the plotted range
        if interp1(Eb_N0_dB,SER(s,:),snr_sim(k))<3e-6
            continue
        end
        sg=sqrt(1/(4*10^(snr_sim(k)/10))/2);
        ser_sim(k)=sim_ser(sets{s,1},sg);
    end
    plot(snr_sim,ser_sim,'o','Color',sets{s,2},'MarkerSize',4);
end
hs=plot(nan,nan,'ko','MarkerSize',4); %legend entry for the simulation markers
hold off

xlim([0 28])
ylim([10^(-6) 1])
xlabel('$E_{b}/N_{0}$ (dB)');
ylabel('SER');
title('SER versus $E_{b}/N_{0}$, proposed constellation');
legend([hl; hs],{'Proposed, max $d_{\min}$, $\varepsilon(x)=0$',...
    'Proposed, PAPR $=3.214$, $\varepsilon(x)=0$',...
    '16-CQAM, $N=4$, $\varepsilon(R_{i})=0$','16-sQAM, $i=4$, $\varepsilon(x)=0$',...
    'Proposed, max $d_{\min}$, $\varepsilon(x)=0.2$',...
    'Proposed, PAPR $=3.214$, $\varepsilon(x)=0.2$',...
    '16-CQAM, $N=4$, $\varepsilon(R_{i})=0.2$','16-sQAM, $i=4$, $\varepsilon(x)=0.2$',...
    'simulation'},'Location','southoutside','NumColumns',2);
grid on

%exportgraphics(gcf,'SER_SNR_prop.pdf','ContentType','vector');

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

function ser=sim_ser(x,sigma)
%Monte Carlo SER with ML detection: batches of 1e6 symbols until 100 errors
%or 1e7 symbols. Returns NaN if fewer than 10 errors were counted.
errors=0;
total=0;
while errors<100 && total<1e7
    tx=randi(numel(x),1e6,1);
    noise=sigma*(randn(1e6,1)+1j*randn(1e6,1));
    [~,rx]=min(abs(x(tx)+noise-x.'),[],2);
    errors=errors+sum(rx~=tx);
    total=total+1e6;
end
ser=errors/total;
if errors<10
    ser=NaN;
end
end

function P=ser_nn(points,sigma)
%union bound of the SER under ML detection
%symbols at the same position cannot be told apart: the detector picks one of them
M=numel(points);
P=zeros(M,numel(sigma));
positions=unique(round(points,12)); %distinct positions of the symbols
for m=1:M
    same=sum(abs(points-points(m))<1e-9); %symbols at the same position, including itself
    dist=abs(positions-points(m));
    others=dist(dist>=1e-9); %distances to the other positions
    p_out=zeros(1,numel(sigma));
    for j=1:numel(others)
        p_out=p_out+qfunc(others(j)./(2*sigma));
    end
    P(m,:)=1-(1/same)*(1-min(p_out,1));
end
P=mean(P,1);
end
