M = 16;
Eb_N0_dB=linspace(0,30); %range of SNR (dB) 
Eb_N0=10.^(Eb_N0_dB./10); 
N0_dB=linspace(0,30); %range of NO (dB) 
N0=10.^(-N0_dB./10);

%16-PAM, ε(x)=0
SER_pam1=(1/16)*(2*qfunc(sqrt((2*12*Eb_N0)/255))...
    +14*2*qfunc(sqrt((2*12*Eb_N0)/255))); 

%16-PAM, ε(x)=0.2
p1=qfunc(0.135./sqrt(0.5*N0));
p2=qfunc(0.1155./sqrt(0.5*N0))+qfunc(0.1136./sqrt(0.5*N0));
p3=qfunc(0.1192./sqrt(0.5*N0))+qfunc(0.1156./sqrt(0.5*N0));
p4=qfunc(0.1192./sqrt(0.5*N0))+qfunc(0.1271./sqrt(0.5*N0));
p5=qfunc(0.127./sqrt(0.5*N0))+qfunc(0.1534./sqrt(0.5*N0));
p6=qfunc(0.1534./sqrt(0.5*N0))+qfunc(0.3068./sqrt(0.5*N0));
p11=qfunc(0.3068./sqrt(0.5*N0))+qfunc(0.1534./sqrt(0.5*N0));
p12=qfunc(0.1534./sqrt(0.5*N0))+qfunc(0.127./sqrt(0.5*N0));
p13=qfunc(0.1271./sqrt(0.5*N0))+qfunc(0.1192./sqrt(0.5*N0));
p14=qfunc(0.1192./sqrt(0.5*N0))+qfunc(0.1156./sqrt(0.5*N0));
p15=qfunc(0.1155./sqrt(0.5*N0))+qfunc(0.1136./sqrt(0.5*N0));
p16=qfunc(0.1135./sqrt(0.5*N0));

SER_pam2=(1/16)*(p1+p2+p3+p4+p5+p6+p11+...
    p12+p13+p14+p15+p16+4*0.5); 

%16-QAM, ε(x)=0  
SER_qam1=1-(1-2*(1-1/(sqrt(M)))*qfunc(sqrt((3/(M-1))*Eb_N0*log2(M)))).^2;

%16-QAM, ε(x)=0.2
p1=((qfunc(sqrt(2)*0.894./sqrt(N0))).^2)...
    .*(1-qfunc(0.3070553426./(sqrt(N0)*sqrt(0.50281622))))...
    .*(1-qfunc(3.197375842./(sqrt(89.27188725)*sqrt(N0))));
pe1=1-p1;
p2=(1-qfunc(0.3075194118./(sqrt(N0)*sqrt(0.50281622))))...
    .*(1-qfunc(0.56566./sqrt(N0)))...
    .*(1-qfunc(sqrt(2)*0.28284./sqrt(N0)));
pe2=1-p2;

SER_qam2=(1/16)*(4*pe1+8*pe2+4*0.5); 

%16-CQAM, ε(Ri)=0
N=4;
n=M/N ;
dmin=0.64;
R1=dmin/sqrt(2);
R2=dmin*((1+sqrt(3))/2);
R3=dmin*((2+sqrt(2))/2);
R4=sqrt(4-5.2802*(dmin)^2);

SER_cqam1 = (1/N)*(4*qfunc(sqrt(sin(pi/n)*R1*Eb_N0)) + ...
    4*qfunc(sqrt(sin(pi/n)*(R2)*Eb_N0))  + ...
    4*qfunc(sqrt(sin(pi/n)*(R3)*Eb_N0))  + ...
    1*qfunc(sqrt(sin(pi/n)*(R4)*Eb_N0))  ); 

%16-CQAM, ε(Ri)=0.2
e_Ri=0.2;

SER_cqam2 = (1/N)*(4*qfunc(sqrt(sin(pi/n).*Eb_N0*sqrt((R1)^2-e_Ri ))) + ...
    4*qfunc(sqrt(sin(pi/n).*Eb_N0*sqrt((R2)^2-e_Ri))) + ...
    2*qfunc(sqrt(sin(pi/n).*Eb_N0*sqrt((R3)^2-e_Ri))) + ...
    1*qfunc(sqrt(sin(pi/n).*Eb_N0*sqrt((R4)^2-e_Ri)))); 

%16-sQAM, i=4, ε(x)=0
%values from [R2]
i=4;
k=(2*(M-1)/3)^(-0.5);
PAPR=3.214;
g=(M-i*sqrt(PAPR))/(M-i);
Dmid=k*sqrt(2*M-8*sqrt(M)+8);
pmax=qfunc((sqrt(PAPR)-Dmid)./sqrt(2*N0)); %SER of spiked symbols
p=2*(1-1/(sqrt(M)))*2*qfunc(k*sqrt(4*Eb_N0.*g*2))...
    -(1-1/(sqrt(M))+1/M)*(2*qfunc(k*sqrt(4*Eb_N0.*g*2))).^2; %SER of 16-RQAM

SER_sqam=((M-i)/M)*p+(i/M)*pmax; 


semilogy(Eb_N0_dB, SER_pam1,'k', Eb_N0_dB, SER_qam1,'b', Eb_N0_dB, SER_cqam1,'r', ...
    Eb_N0_dB, SER_pam2,'k--',Eb_N0_dB, SER_qam2,'b--', Eb_N0_dB, SER_cqam2,'r--',...
    Eb_N0_dB, SER_sqam,'g')
xlim([0 28])
ylim([10^(-6) 1])
xlabel('E_{b}/N_{0} (dB)')
ylabel('SER')
title('SER versus SNR')
legend({'16-PAM, ε(x)=0','16-QAM, ε(x)=0','16-CQAM, N=4, ε(R_{i})=0',...
    '16-PAM, ε(x)=0.2', '16-QAM, ε(x)=0.2','16-CQAM, N=4, ε(R_{i})=0.2',...
    '16-sQAM, ε(x)=0'}, 'Location','southwest')
grid on

%saveas(gcf,'SER_SNR.pdf')

