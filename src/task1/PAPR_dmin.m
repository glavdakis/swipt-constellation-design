%plot style: all text with the LaTeX interpreter (Computer Modern, as in the report)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',11);

M=16;

%% theory
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
dmin_iii=0.63246;
PAPR_iii=1.8;
scatter(dmin_iii,PAPR_iii,"filled","m","o")

%16-CQAM, N=4
dmin_iv=linspace(0,sqrt(2/(3+sqrt(3))),200);
PAPR_iv=4-(3.5+sqrt(3))*dmin_iv.^2;
plot(dmin_iv,PAPR_iv,"r")

%16-CQAM, N=8
dmin_v=linspace(0,2/3,200);
PAPR_v=8-13.25*dmin_v.^2;
plot(dmin_v,PAPR_v,"c")

%% simulation: build every constellation numerically and measure PAPR and dmin
%16-PSK, 16-PAM, 16-QAM
x_psk=exp(1j*2*pi*(0:M-1)'/M);
x_pam=(2*(1:M)'-M-1);
[I,Q]=meshgrid(-3:2:3);
x_qam=I(:)+1j*Q(:);
sim=[measure(x_psk); measure(x_pam); measure(x_qam)];

%16-CQAM: R1's Algorithm 1 run numerically, with the phase of every circle
%chosen to give the smallest radius
for N=[4 8]
    n=M/N;
    for d=0.05:0.05:0.65
        x=cqam_alg1(N,n,d,M);
        if ~isempty(x)
            sim=[sim; measure(x)];
        end
    end
end
h=plot(sim(:,1),sim(:,2),'kx','MarkerSize',7,'LineWidth',1);

xlim([0 0.7])
ylim([0 8])
xlabel('$d_{\min}$');
ylabel('PAPR');
title('PAPR versus $d_{\min}$');
legend({'16-PSK','16-PAM','16-QAM','16-CQAM, $N=4$','16-CQAM, $N=8$','simulation'},...
    'Location','northeast');
grid on;
hold off

%exportgraphics(gcf,'PAPR_dmin.pdf','ContentType','vector');

function out=measure(x)
%dmin and PAPR of a constellation, after normalising it to Es=1
x=x/sqrt(mean(abs(x).^2));
D=abs(x-x.');
D(logical(eye(numel(x))))=inf;
out=[min(D(:)), max(abs(x).^2)];
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
