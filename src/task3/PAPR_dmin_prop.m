%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;

%% theory
%proposed 16-point constellation: 15 hexagonal-lattice points around their
%centroid + 1 spike; it reaches the upper bound PAPR <= 16 - S15*dmin^2
figure('Position',[100 100 560 560]);
h=gobjects(1,5);
dmin_i=linspace(0,15/(4*sqrt(31)),200);
PAPR_i=16-(464/15)*dmin_i.^2;
h(1)=plot(dmin_i,PAPR_i,"k","LineWidth",1.2);
hold on

%16-CQAM, N=4
dmin_ii=linspace(0,sqrt(2/(3+sqrt(3))),200);
PAPR_ii=4-(3.5+sqrt(3))*dmin_ii.^2;
h(2)=plot(dmin_ii,PAPR_ii,"r");

%16-CQAM, N=8
dmin_iii=linspace(0,2/3,200);
PAPR_iii=8-13.25*dmin_iii.^2;
h(3)=plot(dmin_iii,PAPR_iii,"c");

%16-sQAM, 4 symbols spike
dmin_iv=linspace(0,0.63245,200);
PAPR_iv=4-5.5*dmin_iv.^2;
h(4)=plot(dmin_iv,PAPR_iv,"b");

%16-sQAM, 1 symbol spike
dmin_v=linspace(0,0.63246,200);
PAPR_v=16-35.5*dmin_v.^2;
h(5)=plot(dmin_v,PAPR_v,"m");

%% simulation: build every constellation numerically and measure PAPR and dmin
d_grid=0.05:0.05:0.65;
sim=struct('prop',[],'N4',[],'N8',[],'s4',[],'s1',[]);
for d=d_grid
    %proposed constellation
    sim.prop=[sim.prop; measure(prop_points(d))];
    %16-CQAM: R1's Algorithm 1 run numerically, with the phase of every
    %circle chosen to give the smallest radius
    x=cqam_alg1(4,4,d,M);
    if ~isempty(x)
        sim.N4=[sim.N4; measure(x)];
    end
    x=cqam_alg1(8,2,d,M);
    if ~isempty(x)
        sim.N8=[sim.N8; measure(x)];
    end
    %16-sQAM with i=4 and i=1 spikes (valid up to dmin = sqrt(2/5))
    if d<=sqrt(2/5)
        sim.s4=[sim.s4; measure(sqam_points(d,4))];
        sim.s1=[sim.s1; measure(sqam_points(d,1))];
    end
end
plot(sim.prop(:,1),sim.prop(:,2),'ko','MarkerSize',6,'LineWidth',1);
plot(sim.N4(:,1),sim.N4(:,2),'ro','MarkerSize',6,'LineWidth',1);
plot(sim.N8(:,1),sim.N8(:,2),'co','MarkerSize',6,'LineWidth',1);
plot(sim.s4(:,1),sim.s4(:,2),'bo','MarkerSize',6,'LineWidth',1);
plot(sim.s1(:,1),sim.s1(:,2),'mo','MarkerSize',6,'LineWidth',1);
hs=plot(nan,nan,'ko','MarkerSize',6,'LineWidth',1); %legend entry for the simulation markers

xlim([0 0.7])
ylim([0 17])
xlabel('$d_{\min}$');
ylabel('PAPR');
title('PAPR versus $d_{\min}$');
legend([h hs],{'Proposed 16-point constellation','16-CQAM, $N=4$','16-CQAM, $N=8$',...
    '16-sQAM, $i=4$','16-sQAM, $i=1$','simulation'},'Location','southoutside','NumColumns',2);
grid on;
hold off

%exportgraphics(gcf,'PAPR_dmin_prop.pdf','ContentType','vector');

function out=measure(x)
%dmin and PAPR of a constellation, after normalising it to Es=1
x=x/sqrt(mean(abs(x).^2));
D=abs(x-x.');
D(logical(eye(numel(x))))=inf;
out=[min(D(:)), max(abs(x).^2)];
end

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

function x=sqam_points(dmin,i)
%16-sQAM with Es=1: square 16-QAM with spacing dmin, where i of the 4 corner
%symbols are moved outwards on their diagonal and take the rest of the energy
M=16;
[I,Q]=meshgrid((-1.5:1:1.5)*dmin);
x=I(:)+1j*Q(:);
corner=find(abs(abs(real(x))-1.5*dmin)<1e-9 & abs(abs(imag(x))-1.5*dmin)<1e-9);
spikes=corner(1:i);
r2=(M-sum(abs(x).^2)+i*abs(x(spikes(1)))^2)/i; %energy of every spike
x(spikes)=sqrt(r2)*x(spikes)./abs(x(spikes));
end

function x=cqam_alg1(N,n,d,M)
%every circle at the smallest radius that keeps all distances >= d, with the
%phase that gives the smallest radius; the outer circle takes the rest of the
%energy (Es=1). Returns [] if the outer circle cannot be placed.
phases=linspace(0,2*pi/n,2001);
phases(end)=[];
R=d/(2*sin(pi/n));
x=R*exp(1j*(pi/n+2*pi*(0:n-1)'/n));
for i=2:N-1
    best=inf;
    for th=phases
        r=min_radius(x,th,n,d,R(end));
        if r<best-1e-12
            best=r;
            bth=th;
        end
    end
    R(end+1)=best;
    x=[x; best*exp(1j*(bth+2*pi*(0:n-1)'/n))];
end
RN2=M/n-sum(R.^2);
if RN2<R(end)^2
    x=[];
    return
end
RN=sqrt(RN2);
for th=linspace(0,2*pi/n,4001)
    y=RN*exp(1j*(th+2*pi*(0:n-1)'/n));
    if min(abs(y-x.'),[],'all')>=d*(1-1e-9)
        x=[x; y];
        return
    end
end
x=[];
end

function r=min_radius(x,th,n,d,rmin)
%smallest radius >= rmin for n symbols at phase th that are at least d away
%from the symbols x (and from each other)
a=th+2*pi*(0:n-1)/n;
rel=angle(x)-a;
rp=repmat(abs(x),1,n);
disc=d^2-(rp.*sin(rel)).^2;
c=rp.*cos(rel);
lo=c(disc>0)-sqrt(disc(disc>0));
hi=c(disc>0)+sqrt(disc(disc>0));
r=max(rmin,d/(2*sin(pi/n)));
inside=lo<r & r<hi-1e-15;
while any(inside)
    r=max(hi(inside));
    inside=lo<r & r<hi-1e-15;
end
end
