Es=1;
M=16;

%16-PAM
Eg=(3*Es)/(M^2-1);
%energy levels for PAM
e_p1=((15)*sqrt(Eg))^2;
e_p2=((13)*sqrt(Eg))^2;
e_p3=((11)*sqrt(Eg))^2;
e_p4=((9)*sqrt(Eg))^2;
e_p5=((7)*sqrt(Eg))^2;
e_p6=((5)*sqrt(Eg))^2;
e_p7=((3)*sqrt(Eg))^2;
e_p8=((1)*sqrt(Eg))^2;
e_pam=[e_p8, e_p8, e_p7, e_p7, e_p6, e_p6, e_p5, e_p5, e_p4, e_p4, e_p3, e_p3, e_p2, e_p2,... 
    e_p1, e_p1, 4, 4.2]; %range of ε(x) 
SER_pam=[0, 0.125, 0.125, 0.25, 0.25, 0.375, 0.375, 0.5, 0.5, 0.625, 0.625, 0.75, 0.75,...
    0.875, 0.875, 1, 1, 1]; %values of SER

plot(e_pam, SER_pam, 'm-.', 'LineWidth', 1); 
hold on

%16-QAM
%energy levels for QAM
e_q1=0.2048;
e_q2=1.024;
e_q4=1.8432;
e_qam=[e_q1, e_q1, e_q2, e_q2, e_q4, e_q4, 4, 4.2]; %range of ε(x)
SER_qam=[0, 0.25,0.25, 0.75, 0.75, 1, 1, 1]; %values of SER

plot(e_qam, SER_qam, 'k--', 'LineWidth', 1); 


%16-CQAM, max dmin
dmin_i=0.62772;
%energy levels for CQAM, max dmin
e_d1=(dmin_i^2)/2;
e_d2=(dmin_i^2)*((1+sqrt(3))/2)^2;
e_d3=(dmin_i^2)*((2+sqrt(2))/2)^2;
e_d4=4-5.2802*(dmin_i^2); 

e_cqam_dmin=[ e_d1, e_d1, e_d2, e_d2, e_d3, e_d3, e_d4 , e_d4, 4, 4.2]; %range of ε(x)
SER_cqam_dmin=[ 0, 0.25, 0.25, 0.5, 0.5, 0.75, 0.75, 1, 1, 1]; %values of SER

plot(e_cqam_dmin, SER_cqam_dmin, 'b-.', 'LineWidth', 1); 

%16-CQAM, max PAPR
e_cqam_PAPR=[0, 0, 4, 4, 4.2]; %range of ε(x)
SER_cqam_PAPR=[0.25, 0.75, 0.75, 1, 1]; %values of SER

plot(e_cqam_PAPR, SER_cqam_PAPR, 'r', 'LineWidth', 1); 

%16-sQAM, i=4 spiked symbols
dmin_ii=0.378;
%energy levels for sQAM
e_s1=(dmin_ii^2)/2;
e_s2=2.5*dmin_ii^2;
e_s4=4-5.5*dmin_ii^2;
e_sqam=[e_s1, e_s1, e_s2, e_s2, e_s4, e_s4, 4, 4.2]; %range of ε(x)
SER_sqam=[0, 0.25,0.25, 0.75, 0.75, 1, 1, 1]; %values of SER

plot(e_sqam, SER_sqam, 'g--', 'LineWidth', 1); 


xlim([0 4.2])
ylim([0 1])
xlabel('harvested energy ε(x)')
ylabel('SER')
title('SER versus ε(x)')
legend({'PAM, M=16','QAM, M=16', 'CQAM, M=16, N=4, max d_{min}',...
    'CQAM, M=16, N=4, max PAPR','sQAM, M=16, i=4'}, 'Location','southeast')
grid on;
hold off

%saveas(gcf,'SER_energy.pdf')



