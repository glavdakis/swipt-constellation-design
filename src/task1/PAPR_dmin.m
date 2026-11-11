%16-PSK
dmin_i=0.3902;
PAPR_i=1;
scatter(dmin_i,PAPR_i,"filled","g","square")
hold on

%16-PAM
dmin_ii=0.2169;
PAPR_ii=2.647;
scatter(dmin_ii,PAPR_ii,"filled","b","^")

%16-QAM
dmin_iii=0.64;
PAPR_iii=1.8432;
scatter(dmin_iii,PAPR_iii,"filled","m","o")

%16-CQAM, N=4
dmin_iv=linspace(0,0.62772,200);
PAPR_iv=4-5.280239*dmin_iv.^2;
plot(dmin_iv,PAPR_iv,"r")

%16-CQAM, N=8
dmin_v=linspace(0,0.41391,200);
PAPR_v=8-33.446152*dmin_v.^2;
plot(dmin_v,PAPR_v,"c")

xlim([0 0.7])
ylim([0 8])
xlabel('d_{min}')
ylabel('PAPR')
title('PAPR versus d_{min}')
legend({'PSK, M=16','PAM, M=16','QAM, M=16 ','CQAM, M=16, N=4','CQAM, M=16, N=8'},...
    'Location','northeast')
grid on;
hold off

%saveas(gcf,'PAPR_dmin.pdf');
