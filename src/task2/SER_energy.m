%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

%SER versus harvested energy at very high SNR.
%A symbol whose energy is at most ε(x) moves to the origin. If k symbols are
%at the origin, the ML detector cannot tell them apart and decides correctly
%for only one of them, so SER = (k-1)/M.
Es=1;
M=16;
e_x=linspace(0,4.2,4201); %range of ε(x)

%16-PAM
Eg=(3*Es)/(M^2-1);
E_pam=((2*(1:M)-M-1).^2)*Eg; %energies of the 16 symbols

%16-QAM
d=sqrt(2/5);
E_qam=[repmat(d^2/2,1,4), repmat(5*d^2/2,1,8), repmat(9*d^2/2,1,4)];

%16-CQAM, N=4, max dmin
dmin_i=0.65012;
R=[dmin_i/sqrt(2) dmin_i*((1+sqrt(3))/2) dmin_i*sqrt(2+sqrt(3)/2) ...
    sqrt(4-(3.5+sqrt(3))*dmin_i^2)];
E_cqam_dmin=repelem(R.^2,4);

%16-CQAM, N=4, max PAPR (dmin=0)
E_cqam_PAPR=[zeros(1,12), repmat(4,1,4)];

%16-sQAM, i=4 spiked symbols
dmin_ii=0.378;
E_sqam=[repmat(dmin_ii^2/2,1,4), repmat(2.5*dmin_ii^2,1,8), repmat(4-5.5*dmin_ii^2,1,4)];

ser=@(E) max(sum(E(:)<=e_x,1)-1,0)/M; %SER for every value of ε(x)

hl(1)=plot(e_x, ser(E_pam), 'm-.', 'LineWidth', 1);
hold on
hl(2)=plot(e_x, ser(E_qam), 'k--', 'LineWidth', 1);
hl(3)=plot(e_x, ser(E_cqam_dmin), 'b-.', 'LineWidth', 1);
hl(4)=plot(e_x, ser(E_cqam_PAPR), 'r', 'LineWidth', 1);
hl(5)=plot(e_x, ser(E_sqam), 'g--', 'LineWidth', 1);

%% simulation: Monte Carlo with ML detection at very high SNR (Eb/N0 = 60 dB)
rng(1);
EbN0=10^(60/10);
sigma=sqrt(1/(4*EbN0)/2); %Es=4Eb=1
e_sim=0:0.1:4.2;
Nsym=2e4;
%symbol positions of every constellation
x_pam=(2*(1:M)'-M-1)*sqrt(Eg);
[I,Q]=meshgrid((-1.5:1:1.5)*d);
x_qam=I(:)+1j*Q(:);
ph=[pi/4, 0, atan(sqrt(3)-1), atan(1+2/sqrt(3))];
x_cqam_dmin=reshape(R.*exp(1j*(ph+2*pi*(0:3)'/4)),[],1);
x_cqam_PAPR=[zeros(12,1); 2*exp(1j*2*pi*(0:3)'/4)];
[I,Q]=meshgrid((-1.5:1:1.5)*dmin_ii);
x_sqam=I(:)+1j*Q(:);
corner=abs(abs(real(x_sqam))-1.5*dmin_ii)<1e-9 & abs(abs(imag(x_sqam))-1.5*dmin_ii)<1e-9;
x_sqam(corner)=sqrt(E_sqam(end)/2)*(sign(real(x_sqam(corner)))+1j*sign(imag(x_sqam(corner))));

sets={x_pam,'m';x_qam,'k';x_cqam_dmin,'b';x_cqam_PAPR,'r';x_sqam,'g'};
for s=1:size(sets,1)
    ser_sim=sim_ser(sets{s,1},e_sim,sigma,Nsym,s==1);
    plot(e_sim,ser_sim,'o','Color',sets{s,2},'MarkerSize',4);
end
hs=plot(nan,nan,'ko','MarkerSize',4); %legend entry for the simulation markers

xlim([0 4.2])
ylim([0 1])
xlabel('Harvested energy $\varepsilon(x)$');
ylabel('SER');
title('SER versus $\varepsilon(x)$');
legend([hl hs],{'16-PAM','16-QAM','16-CQAM, $N=4$, max $d_{\min}$',...
    '16-CQAM, $N=4$, max PAPR','16-sQAM, $i=4$','simulation'},'Location','southeast');
grid on;
hold off

%exportgraphics(gcf,'SER_energy.pdf','ContentType','vector');

function ser=sim_ser(x,e_grid,sigma,Nsym,real1d)
%Monte Carlo SER after harvesting energy e from every symbol (ML detection;
%symbols at the same position are decided as the first of them)
ser=zeros(size(e_grid));
for k=1:numel(e_grid)
    r=abs(x);
    y=x.*sqrt(max(r.^2-e_grid(k),0))./max(r,eps); %symbols after harvesting
    tx=randi(numel(y),Nsym,1);
    noise=sigma*randn(Nsym,1);
    if ~real1d
        noise=noise+1j*sigma*randn(Nsym,1);
    end
    [~,rx]=min(abs(y(tx)+noise-y.'),[],2);
    ser(k)=mean(rx~=tx);
end
end
