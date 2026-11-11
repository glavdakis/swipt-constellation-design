M = 16;
Eg=0.01176;
i=linspace(1,M,16);
x=(2*i-M-1)*sqrt(Eg);
y=0;

figure;
plot(x,y,"x");
axis square;
mycolors = [0 0 1];
ax = gca; 
ax.ColorOrder = mycolors;
grid on;
title('16-PAM');

%saveas(gcf, 'PAM_16.pdf');