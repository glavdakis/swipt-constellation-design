%16-QAM
c=15.44016936;
dmin_i=linspace(0,0.5332255829,200);
PAPR_i=16-3*c*dmin_i.^2;
plot(dmin_i,PAPR_i,"g")
hold on

%16-CQAM, N=4
dmin_ii=linspace(0,0.62772,200);
PAPR_ii=4-5.280239*dmin_ii.^2;
plot(dmin_ii,PAPR_ii,"r")

%16-CQAM, N=8
dmin_iii=linspace(0,0.41391,200);
PAPR_iii=8-33.446152*dmin_iii.^2;
plot(dmin_iii,PAPR_iii,"c")

%16-sQAM, 4 symbols spike
dmin_iv=linspace(0,0.63245,200);
PAPR_iv=4-5.5*dmin_iv.^2;
plot(dmin_iv,PAPR_iv,"b")

%16-sQAM, 1 symbol spike
dmin_v=linspace(0,0.65103,200);
PAPR_v=16-35.5*dmin_v.^2;
plot(dmin_v,PAPR_v,"m")


xlim([0 0.7])
ylim([0 17])
xlabel('d_{min}')
ylabel('PAPR')
title('PAPR versus d_{min}')
legend({'proposed QAM, M=16, N=5','CQAM, M=16, N=4','CQAM, M=16, N=8','sQAM, M=16, 4 spiked symbols',...
    'sQAM, M=16, 1 spiked symbol'}, 'Location','northeast')
grid on;
hold off
   
%saveas(gcf,'PAPR_dmin_NEW.pdf');
