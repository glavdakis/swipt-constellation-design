%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M = 16;
Eb_N0_dB=linspace(0,30); %range of SNR (dB)
Eb_N0=10.^(Eb_N0_dB./10);
N0=1./(4*Eb_N0); %Es=4Eb=1
sigma=sqrt(N0/2); %noise standard deviation per dimension
e_x=0.2; %harvested energy

%16-PAM, ε(x)=0
SER_pam1=(1/16)*(2*qfunc(sqrt((2*12*Eb_N0)/255))...
    +14*2*qfunc(sqrt((2*12*Eb_N0)/255)));

%16-PAM, ε(x)=0.2
Eg=3/(M^2-1);
a=(1:2:15)*sqrt(Eg); %amplitudes of s9,...,s16
s=sqrt(max(a.^2-e_x,0)); %amplitudes after harvesting: s9=s10=0
s_pos=s(3:8); %s11,...,s16
b0=s_pos(1)/2; %decision boundary between the origin and s11
half=diff(s_pos)/2; %half distances between consecutive symbols
p11=qfunc(b0./sigma)+qfunc(half(1)./sigma);
p12=qfunc(half(1)./sigma)+qfunc(half(2)./sigma);
p13=qfunc(half(2)./sigma)+qfunc(half(3)./sigma);
p14=qfunc(half(3)./sigma)+qfunc(half(4)./sigma);
p15=qfunc(half(4)./sigma)+qfunc(half(5)./sigma);
p16=qfunc(half(5)./sigma);
p0=1-(1/4)*(1-2*qfunc(b0./sigma)); %s7,...,s10: 4 symbols at the origin

SER_pam2=(1/16)*(2*(p11+p12+p13+p14+p15+p16)+4*p0);

%16-QAM, ε(x)=0
SER_qam1=1-(1-2*(1-1/(sqrt(M)))*qfunc(sqrt((3/(M-1))*Eb_N0*log2(M)))).^2;

%16-QAM, ε(x)=0.2
d=sqrt(2/5); %dmin of 16-QAM for Es=1
s4a=sqrt((9*d^2/2-e_x)/(9*d^2/2))*[3 3]*d/2; %outer symbol
s3a=sqrt((5*d^2/2-e_x)/(5*d^2/2))*[3 1]*d/2; %middle symbol
s2a=fliplr(s3a); %middle symbol, mirrored on y=x
%d1^2=e_x, so the 4 inner symbols are at the origin
h43=norm(s4a-s3a)/2; %distance of s4a and s3a from the bisector C1 (and of s4a from C2)
h33=s3a(2); %distance of s3a from y=0
h32=norm(s3a-s2a)/2; %distance of s3a from y=x
h30=norm(s3a)/2; %distance of s3a from the bisector with the origin
pe1=1-((1-qfunc(s4a(1)./sigma)).^2).*((1-qfunc(h43./sigma)).^2);
pe2=1-(1-qfunc(h33./sigma)).*(1-qfunc(h32./sigma))...
    .*(1-qfunc(h43./sigma)).*(1-qfunc(h30./sigma));
pe0=1-(1/4)*(1-qfunc(h30./sigma)).^8; %4 symbols at the origin

SER_qam2=(1/16)*(4*pe1+8*pe2+4*pe0);

%16-CQAM, N=4, max dmin
N=4;
n=M/N;
dmin=0.65012;
R=[dmin/sqrt(2) dmin*((1+sqrt(3))/2) dmin*sqrt(2+sqrt(3)/2) ...
    sqrt(4-(3.5+sqrt(3))*dmin^2)];
phaseOffsets=[pi/4, 0, atan(sqrt(3)-1), atan(1+2/sqrt(3))];

%16-CQAM, ε(Ri)=0
SER_cqam1=ser_nn(cqam_points(R,phaseOffsets,n),sigma);

%16-CQAM, ε(Ri)=0.2
R_h=sqrt(max(R.^2-e_x,0)); %radii after harvesting
SER_cqam2=ser_nn(cqam_points(R_h,phaseOffsets,n),sigma);

%16-sQAM, i=4, ε(x)=0
%values from [R2]
i=4;
k=(2*(M-1)/3)^(-0.5);
PAPR=3.214;
g=(M-i*PAPR)/(M-i); %relation (8) of [R2]
Dmid=k*sqrt(2*M-8*sqrt(M)+8);
pmax=qfunc((sqrt(PAPR)-Dmid)./sqrt(2*N0)); %SER of spiked symbols
p=2*(1-1/(sqrt(M)))*2*qfunc(k*sqrt(4*Eb_N0.*g*2))...
    -(1-2/(sqrt(M))+1/M)*(2*qfunc(k*sqrt(4*Eb_N0.*g*2))).^2; %SER of 16-RQAM

SER_sqam_R2=((M-i)/M)*p+(i/M)*pmax; %approximation (7) of [R2], not plotted

%[R2] treats the 12 inner symbols as a full 16-QAM scaled by sqrt(γ)
%(dmin=2k*sqrt(γ)=0.324 instead of the actual 0.378), so (7) overestimates
%the SER. The plotted curve is the union bound on the actual constellation.
dmin_s=0.378;
[I,Q]=meshgrid((-1.5:1:1.5)*dmin_s);
sqam=I(:)+1j*Q(:);
corner=abs(abs(real(sqam))-1.5*dmin_s)<1e-9 & abs(abs(imag(sqam))-1.5*dmin_s)<1e-9;
d4I=sqrt((4-5.5*dmin_s^2)/2); %projection of the spiked symbols on the I and Q axes
sqam(corner)=d4I*(sign(real(sqam(corner)))+1j*sign(imag(sqam(corner))));
SER_sqam=ser_nn(sqam,sigma);

%16-sQAM, i=4, ε(x)=0.2 (union bound on the symbols after harvesting)
harvest=@(x,e) x.*sqrt(max(abs(x).^2-e,0))./max(abs(x),eps);
SER_sqam2=ser_nn(harvest(sqam,e_x),sigma);

figure('Position',[100 100 560 620]);
hl=semilogy(Eb_N0_dB, SER_pam1,'k', Eb_N0_dB, SER_qam1,'b', Eb_N0_dB, SER_cqam1,'r', ...
    Eb_N0_dB, SER_pam2,'k--',Eb_N0_dB, SER_qam2,'b--', Eb_N0_dB, SER_cqam2,'r--',...
    Eb_N0_dB, SER_sqam,'g', Eb_N0_dB, SER_sqam2,'g--');
hold on

%% simulation: Monte Carlo with ML detection
%symbols at the same position are decided as the first of them
rng(1);
x_pam=(2*(1:M)'-M-1)*sqrt(Eg);
[I,Q]=meshgrid((-1.5:1:1.5)*d);
x_qam=I(:)+1j*Q(:);
x_cqam=cqam_points(R,phaseOffsets,n);
sets={x_pam,0,SER_pam1,'k'; harvest(x_pam,e_x),0,SER_pam2,'k';
    x_qam,1,SER_qam1,'b'; harvest(x_qam,e_x),1,SER_qam2,'b';
    x_cqam,1,SER_cqam1,'r'; harvest(x_cqam,e_x),1,SER_cqam2,'r';
    sqam,1,SER_sqam,'g'; harvest(sqam,e_x),1,SER_sqam2,'g'};
snr_sim=0:2:28;
for s=1:size(sets,1)
    ser_sim=nan(size(snr_sim));
    for k=1:numel(snr_sim)
        %skip points below the plotted range
        if interp1(Eb_N0_dB,sets{s,3},snr_sim(k))<3e-6
            continue
        end
        sg=sqrt(1/(4*10^(snr_sim(k)/10))/2);
        ser_sim(k)=sim_ser(sets{s,1},sg,sets{s,2}==1);
    end
    plot(snr_sim,ser_sim,'o','Color',sets{s,4},'MarkerSize',4);
end
hs=plot(nan,nan,'ko','MarkerSize',4); %legend entry for the simulation markers
hold off

xlim([0 28])
ylim([10^(-6) 1])
xlabel('$E_{b}/N_{0}$ (dB)');
ylabel('SER');
title('SER versus $E_{b}/N_{0}$');
legend([hl; hs],{'16-PAM, $\varepsilon(x)=0$','16-QAM, $\varepsilon(x)=0$',...
    '16-CQAM, $N=4$, $\varepsilon(R_{i})=0$','16-PAM, $\varepsilon(x)=0.2$',...
    '16-QAM, $\varepsilon(x)=0.2$','16-CQAM, $N=4$, $\varepsilon(R_{i})=0.2$',...
    '16-sQAM, $i=4$, $\varepsilon(x)=0$','16-sQAM, $i=4$, $\varepsilon(x)=0.2$',...
    'simulation'},'Location','southoutside','NumColumns',2);
grid on

%exportgraphics(gcf,'SER_SNR.pdf','ContentType','vector');

function ser=sim_ser(x,sigma,complex_noise)
%Monte Carlo SER with ML detection: batches of 1e6 symbols until 100 errors
%or 1e7 symbols. Returns NaN if fewer than 10 errors were counted.
errors=0;
total=0;
while errors<100 && total<1e7
    tx=randi(numel(x),1e6,1);
    noise=sigma*randn(1e6,1);
    if complex_noise
        noise=noise+1j*sigma*randn(1e6,1);
    end
    [~,rx]=min(abs(x(tx)+noise-x.'),[],2);
    errors=errors+sum(rx~=tx);
    total=total+1e6;
end
ser=errors/total;
if errors<10
    ser=NaN;
end
end

function points=cqam_points(R,phaseOffsets,n)
%symbols of a CQAM with radii R and the given phase offset per circle
points=[];
for i=1:numel(R)
    points=[points; R(i)*exp(1j*(phaseOffsets(i)+2*pi*(0:n-1)'/n))];
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
