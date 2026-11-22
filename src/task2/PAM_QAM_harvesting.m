%16-PAM and 16-QAM after harvesting energy ε(x)=0.2 from every symbol,
%with the new ML decision regions
%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;
e_x=0.2;

%16-PAM, ε(x)=0.2
Eg=3/(M^2-1);
a=(2*(1:M)-M-1)*sqrt(Eg); %amplitudes of s1,...,s16
s=sign(a).*sqrt(max(a.^2-e_x,0)); %amplitudes after harvesting
pos=unique(s); %distinct positions: s7,...,s10 are all at the origin
bounds=(pos(1:end-1)+pos(2:end))/2; %ML decision boundaries

figure('Position',[100 100 900 260]);
hold on
plot([-1.75 1.75],[0 0],'k','LineWidth',0.5);
for b=bounds
    plot([b b],[-0.12 0.12],'Color',[0 0.5 0],'LineWidth',1.2);
end
zero=abs(s)<1e-12;
plot(s(~zero),zeros(1,sum(~zero)),'o','Color',[0 0.447 0.741]);
plot(0,0,'o','Color',[0 0.447 0.741]);
for i=find(~zero)
    if mod(i,2)==1
        y=0.07;
    else
        y=-0.07;
    end
    text(s(i),y,sprintf('$s_{%d}$',i),'HorizontalAlignment','center');
end
text(0,0.07,'$s_{7},\dots,s_{10}$','HorizontalAlignment','center');
hold off
xlim([-1.75 1.75])
ylim([-0.2 0.2])
yticks([])
xlabel('In-phase');
title('16-PAM, $\varepsilon(x)=0.2$');

%exportgraphics(gcf,'PAM_harvest.pdf','ContentType','vector')

%16-QAM, ε(x)=0.2
d=sqrt(2/5); %dmin of 16-QAM for Es=1
[I,Q]=meshgrid((-1.5:1:1.5)*d);
q=I(:)+1j*Q(:);
r=q.*sqrt(max(abs(q).^2-e_x,0))./abs(q); %symbols after harvesting
r(abs(r)<1e-12)=0; %the 4 inner symbols are at the origin
pts=unique(round(r,12)); %distinct positions

figure;
hold on
[vx,vy]=voronoi(real(pts),imag(pts)); %ML decision boundaries
plot(vx,vy,'Color',[0 0.5 0],'LineWidth',1.2);
outer=pts(abs(pts)>1e-12);
plot(real(outer),imag(outer),'o','Color',[0 0.447 0.741]);
plot(0,0,'o','Color',[0 0.447 0.741]);

%labels as in the text: a, b, c, d for the 1st, 2nd, 3rd, 4th quadrant
quad='abcd';
for k=1:numel(outer)
    p=outer(k);
    ang=mod(angle(p),2*pi);
    qd=quad(floor(ang/(pi/2))+1);
    if abs(abs(real(p))-abs(imag(p)))<1e-9
        lvl=4;
    elseif abs(real(p))>abs(imag(p))
        lvl=3;
    else
        lvl=2;
    end
    text(real(p)*1.18,imag(p)*1.18,sprintf('$s_{%d%s}$',lvl,qd),'HorizontalAlignment','center');
end
text(0.16,-0.12,'$s_{1a},\dots,s_{1d}$');
hold off
axis equal
xlim([-1.6 1.6])
ylim([-1.6 1.6])
grid on
xlabel('In-phase');
ylabel('Quadrature');
title('16-QAM, $\varepsilon(x)=0.2$');

%exportgraphics(gcf,'QAM_harvest.pdf','ContentType','vector')
