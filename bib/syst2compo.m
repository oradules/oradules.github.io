a1=4.0;a2=a1;
x=0.01:0.001:1.4*a1;

figure(1)
subplot(1,2,1)
hold off
plot(a1./(1+x.^2),x)
hold on
plot(x,a2./(1+x.^2))
r=roots([1,-a1,2,-2*a1,1+a2^2,-a1]);
iplus=find(r>0);
u=r(iplus);
v=a2./(1+u.^2);
plot(u,v,'o')
xlabel('u')
ylabel('v')
axis square
%title('positions des points fixes')

[uu,vv]=meshgrid(0:0.5:1.2*a1);
tau1=0.01;
tau2=tau1;
alpha1=a1/tau1;
alpha2=a2/tau2;
du=-uu/tau1+alpha1./(1+vv.^2);
dv=-vv/tau2+alpha2./(1+uu.^2);
quiver(uu,vv,du,dv)

figure(1)
subplot(1,2,2)
hold off
plot(a1./(1+x.^2),x)
hold on
plot(x,a2./(1+x.^2))
r=roots([1,-a1,2,-2*a1,1+a2^2,-a1]);
iplus=find(r>0);
u=r(iplus);
v=a2./(1+u.^2);
plot(u,v,'o')
xlabel('u')
ylabel('v')
axis square

global R01 R02 P01 P02 nu1 nu2 n1 n2 k1 k2 k2 k3 km3 k4 km4 k5 km5 k6 km6 k7 k8
%%% tester parametres
nu1=2;
nu2=nu1;
%%% amp est la concentration de molecules X dans l'etat stationnaire
amp1=1.0;amp2=1.0;scale =10;tmax=0.1;t1=tmax;t2=tmax;
%R01=amp1;R02=amp2;P01=amp1/10;P02=amp2/10;


tau1=0.1;
P01=max(u)*amp1*2;P01=1;
P02=max(v)*amp1*2;P02=P01;
tau2=tau1;
alpha1=a1/tau1;
alpha2=a2/tau2;
chi3=amp1^(-nu1/2);
chi4=amp2^(-nu2/2);
chi5=chi3;
chi6=chi4;
n1=1;n2=1;
k1=1/tau1;
k2=1/tau2;
k3=k2*10;
km3=k3/chi3;
k4=k3;
km4=km3;
k5=k4;
km5=km4;
k6=k5;km6=km5;
k7=alpha1/(n1*P02*(chi3*chi5)^(1/nu1));
k8=alpha2/(n2*P01*(chi4*chi6)^(1/nu2));
%%%%%%%%%%%%%%%%%%
r1=(1/(chi3*chi5)^(1/nu1))*u %%donne points attracteurs
r2=(1/(chi4*chi6)^(1/nu2))*v
r1nu1=chi3*r1.^nu1
r2nu2=chi4*r2.^nu2
p1=P01./(chi3*chi5*r1.^nu1+1)
p2=P02./(chi4*chi6*r2.^nu2+1)


netat=1;
 %etat0=[round(r1(netat)),round(r2(netat)),0,0,P01,P02];
etat0=[r1(netat),r2(netat),r1nu1(netat),...
        r2nu2(netat),p1(netat),p2(netat)];




%%%%%%%%%% integrer systeme differentiel
xo=etat0';to=0;tf=tmax;
oldoptions=odeset;
%options=odeset(oldoptions,'RelTol',1e-6,'Refine',1);
%[t,x]=ode23t('dynbis2compo',[to tf],xo,options);
[t,x]=ode23t('dynbis2compo',[to tf],xo);

figure(2)
subplot(3,2,1)
hold off
plot(t,x(:,1),'c','Linewidth',4);%%Plot avec couleur cyan la courbe de R1
hold on
plot([0 tmax],[r1(1), r1(1)],'k','Linewidth',2)%%plot la droite y=R1 du premier etat stationnaire stable (stabilite??)
plot([0 tmax],[r1(3), r1(3)],'k','Linewidth',2)%%trace la droite y=R1 du deuxime etat staionnaire stable
plot([0 tmax],[r1(2), r1(2)],'k--','Linewidth',2)

ymax=max(r1);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('R1')
xlabel('temps')

subplot(3,2,2)
hold off
plot(t,x(:,2),'g','Linewidth',4)%%trace avec couleur vert la courbe de R2
hold on
plot([0 tmax],[r2(1),r2(1)],'k','Linewidth',2) 
plot([0 tmax],[r2(3),r2(3)],'k','Linewidth',2)
plot([0 tmax],[r2(2), r2(2)],'k--','Linewidth',2)
ymax=max(r2);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('R2')
xlabel('temps')

subplot(3,2,3)
hold off
plot(t,x(:,3),'c','Linewidth',4);
hold on
plot([0 tmax],[r1nu1(1),r1nu1(1)],'k','Linewidth',2)
plot([0 tmax],[r1nu1(3),r1nu1(3)],'k','Linewidth',2)
plot([0 tmax],[r1nu1(2), r1nu1(2)],'k--','Linewidth',2)
ymax=max(r1nu1);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('R1nu1')
xlabel('temps')

subplot(3,2,4)
hold off
plot(t,x(:,4),'g','Linewidth',4);
hold on
plot([0 tmax],[r2nu2(1),r2nu2(1)],'k','Linewidth',2)
plot([0 tmax],[r2nu2(3),r2nu2(3)],'k','Linewidth',2)
plot([0 tmax],[r2nu2(2), r2nu2(2)],'k--','Linewidth',2)
ymax=max(r2nu2);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('R2nu2')
xlabel('temps')

subplot(3,2,5)
hold off
plot(t,x(:,5),'c','Linewidth',4);  
hold on
plot([0 tmax],[p1(1),p1(1)],'k','Linewidth',2)
plot([0 tmax],[p1(3),p1(3)],'k','Linewidth',2)
plot([0 tmax],[p1(2), p1(2)],'k--','Linewidth',2)
ymax=max(p1);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('P1')
xlabel('temps')

subplot(3,2,6)
hold off
plot(t,x(:,6),'g','Linewidth',4);
hold on
plot([0 tmax],[p2(1),p2(1)],'k','Linewidth',2)
plot([0 tmax],[p2(3),p2(3)],'k','Linewidth',2)
plot([0 tmax],[p2(2),p2(2)],'k--','Linewidth',2)
ymax=max(p2);ymin=-0.1*ymax;ymax=1.2*ymax;
axis([0, tmax ,ymin, ymax]);%%zoom
ylabel('P2')
xlabel('temps')

%title(cat(2,'mc= ',cat(2,num2str(mc),cat(2,' k1= ',cat(2,num2str(k1),cat(2,' k2= ',num2str(k2)))))))
%%%refaire titre avec parametres laisses libres


rand('state',sum(100*clock))
saut=[-1,0,0,0,0,0;0,-1,0,0,0,0;-nu1,0,1,0,0,0; ...
0,-nu2,0,1,0,0;0,0,-1,0,-1,0;0,0,0,-1,0,-1;n1,0,0,0,0,0;0,n2,0,0,0,0];

NN=1000000;
%%% decrire une trajectoire de longueur NN
time=ones(1,NN);x1=time;x2=time;x3=time;x4=time;x5=time;x6=time;

%rescaler les parametres
R01=R01*scale,R02=R02*scale,P01=P01*scale,P02=P02*scale,k3=k3/scale^(nu1-1),...
k4=k4/scale^(nu2-1),k5=k5/scale,k6=k6/scale;
etat0=round(etat0*scale);

k1o=k1;k2o=k2;
stochastic=1;
if stochastic==1
mc=1;

t2abs=zeros(mc,1);
for iii=1:mc
iii
%%% etat initial
x=etat0;
xtest=x;
ii=0;
tt=0;



absorb=0;
figure(1)
subplot(1,2,2)
while tt < tmax & ii < NN & absorb < 1
ii=ii+1;



if tt > t1 & tt < t2
   k1=k1o*100;
   k2=k2o/100;
else
    k1=k1o;
    k2=k2o;
end    


% calculer les densites de proba des reactions
a=[k1*x(1),k2*x(2),k3*x(1)^nu1,k4*x(2)^nu2,k5*x(3)*x(5),k6*x(4)*x(6),k7*x(6),k8*x(5)];
am=[km3*x(3),km4*x(4),km5*(P01-x(5)),km6*(P02-x(6))];
aa=cat(2,a,am);
aa=max(aa,0);
tot=sum(aa);

% temps a la prochaine reaction
if tot>0.0 
tau=-log(rand(1))/tot;
else
tau=tmax;
end
if ii>1
	time(ii)=time(ii-1)+tau;
else
        time(ii)=tau;
end
tt=time(ii);

if mod(ii,10000)==0
ii%%%permet de voir ou en sont les calculs
cat(2,'time=',num2str(tt))
end


if tot>0.0
a=rand(1);
cum=0;
i=0;
while cum < a
i=i+1;
cum=cum+aa(i)/tot;
end
% activer la reaction i, calculer l'etat
signe=1;
if i>8
   i=i-6;
   signe=-1;
end
for j=1:6
	xtest(j)=x(j)+signe*saut(i,j);
end





%%% reaction effective seulement si l'etat suivant est dans N^4
if xtest(1)>-0.1 & xtest(2)>-0.1 & xtest(3)>-0.1 & xtest(4)>-0.1 & xtest(5)>-0.1 & xtest(6)>-0.1
if max(abs(x-xtest))>0.5
    uu=x(1)*chi3/scale;
    vv=x(2)*chi4/scale;
    plot(uu,vv,'r.')
end    
x=xtest;
end

end %% if tot

%if abs(x(1)*beta1-u(1))<0.1 & abs(x(2)*beta2-v(1))<0.1 & abs(chi5*x(3)-u(1)^nu1)< 0.1 & abs(chi6*x(4)-v(1)^nu2)<0.1 & abs(x(5)-P01/(1+u(1)^nu1))<0.1 & abs(x(6)-P02/(1+v(1)^nu2))<0.1 
%absorb=1
%end
%%%autre etat absorbant
%if abs(x(1)*beta1-u(43))<0.1 & abs(x(2)*beta2-v(43))<0.1 & abs(chi5*x(3)-u(43)^nu1)< 0.1 & abs(chi6*x(4)-v(43)^nu2)<0.1 & abs(x(5)-P01/(1+u(43)^nu1))<0.1 & abs(x(6)-P02/(1+v(43)^nu2))<0.1 
%absorb=1
%end



%%%%%%%%%%%%
x1(ii)=x(1);x2(ii)=x(2);x3(ii)=x(3);x4(ii)=x(4);x5(ii)=x(5);x6(ii)=x(6);

end %%% while tt
figure(2)
subplot(3,2,1)
plot(time(1:ii),x1(1:ii)/scale,'b')
hold on

subplot(3,2,2)
if iii==0
hold off
end
plot(time(1:ii),x2(1:ii)/scale,'r')
hold on

subplot(3,2,3)
if iii==0
hold off
end  
plot(time(1:ii),x3(1:ii)/scale,'b');hold on; 


subplot(3,2,4)
if iii==0
hold off
end 

plot(time(1:ii),x4(1:ii)/scale,'r')
hold on

subplot(3,2,5)
if iii==0
hold off
end  
plot(time(1:ii),x5(1:ii)/scale,'b');hold on; 


subplot(3,2,6)
if iii==0
hold off
end 
plot(time(1:ii),x6(1:ii)/scale,'r');hold on;


if absorb==1
t2abs(iii)=time(ii);
else
t2abs(iii)=tmax;
end

end %% monte carlo

end %% stochastic


return

%%% distribution des temps de sortie 
nbins=10;
[eff,val]=hist(t2abs,nbins);
ind=find(eff>0);
x=val(ind);
y=log(eff(ind));
figure(3)
subplot(2,1,1)
hist(t2abs,nbins)
subplot(2,1,2)
hold off
plot(x,y,'x')%%trace par petites croix
a=polyfit(x,y,1)
hold on
plot(x,a(1)*x+a(2))
%%% temps moyen
-1/a(1)