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

plot(e_x, ser(E_pam), 'm-.', 'LineWidth', 1);
hold on
plot(e_x, ser(E_qam), 'k--', 'LineWidth', 1);
plot(e_x, ser(E_cqam_dmin), 'b-.', 'LineWidth', 1);
plot(e_x, ser(E_cqam_PAPR), 'r', 'LineWidth', 1);
plot(e_x, ser(E_sqam), 'g--', 'LineWidth', 1);

xlim([0 4.2])
ylim([0 1])
xlabel('Harvested energy $\varepsilon(x)$');
ylabel('SER');
title('SER versus $\varepsilon(x)$');
legend({'16-PAM','16-QAM','16-CQAM, $N=4$, max $d_{\min}$',...
    '16-CQAM, $N=4$, max PAPR','16-sQAM, $i=4$'},'Location','southeast');
grid on;
hold off

%exportgraphics(gcf,'SER_energy.pdf','ContentType','vector');
