global D0 nu n k1 km1 k2 km2 k3 km3 k4 k5 beta alpha sigma
figures=0;record=1;mc=100;
tmax=2000;
NN=2000000;
tmoy1=ones(5,1);
tmoy2=tmoy1;err=tmoy1;kolmo=tmoy1;probabs=tmoy1;
for ipar=1:3
%%% tester parametres
nu=2;
%%% amp est la concentration de molecules X dans l'etat stationnaire
scale=10+ipar*2;
amp=1.0;
beta=(amp*scale)^(-nu);
epsilon=scale^(2-nu);
sigma=1;
gama=sigma*beta^2;
alpha=(2+sigma)*beta^(1-1/nu);
chi1=sqrt(beta*epsilon);
chi2=beta/chi1;chi3=sigma*chi2;
X0=amp*scale;D0=amp/2*scale;
Xnui=chi1*X0^nu;
Di=D0/(1+(chi3*Xnui+1)*Xnui*chi2);
D1i=D0*chi2*Xnui/(1+(chi3*Xnui+1)*Xnui*chi2);

n=5;
k1=30/scale^(nu-1);
km1=k1/chi1;
k2=30/scale;
km2=k2/chi2;
k3=30/scale;
km3=k3/(sigma*chi2);
%%% en fait k4*P
k5=1;
k4=k5*alpha/(n*beta*D0);
%%%%%%%%%%%%%%%%%%

etat0=[X0,round(Xnui),round(Di),round(D1i)];
xmax=200;
x=0:0.001:1.2;
y=-x+alpha*beta^(1/nu-1)*x.^nu./(1+x.^nu+sigma*x.^(2*nu));

if figures==1
figure(1)
subplot(2,2,1)
hold off
plot(x,y);
yred=-1+alpha*beta^(1/nu-1)*x.^(nu-1)./(1+x.^nu+sigma*x.^(2*nu));
ind=find(abs(yred)<1e-3);
xx=x(ind)
xn=sqrt(beta)*xx.^nu
%d=D0./(1+(sigma*sqrt(beta)*xn+1).*xn*sqrt(beta))
%d1=sqrt(beta)*xn.*d
title('Position des points fixes')
xlabel('X')
ylabel('f(X)')
ymax=max(y);
hold on
plot(0,0,'o')
plot(xx(1:2),[0,0],'o')
plot([0, 1.2*xx(2)],[0, 0])
axis([0, 1.2*xx(2), -1.2*ymax, 1.2*ymax ])
x=0.01:0.01:1.2;
subplot(2,2,2)
hold off
plot(x,fu(x))
xlabel('X')
ylabel('f(X)')
subplot(2,2,3)
hold off
plot(x,ssu(x))
xlabel('X')
ylabel('\sigma^2(X)')
subplot(2,2,4)
hold off
plot(x,funct(x))
xlabel('X')
ylabel('F(X)/\sigma^2(X)')
end % if

rand('state',sum(100*clock))
saut=[-nu,1,0,0;0,-1,-1,1;0,-1,0,-1;n,0,0,0;-1,0,0,0];

%%% decrire une trajectoire de longueur NN
time=ones(1,NN);x1=time;x2=time;x3=time;x4=time;

if figures == 1
figure(2)
end % if
t2abs=zeros(mc,1);
nabs=0;
for iii=1:mc
iii
ipar
%%% etat initial
x=etat0;
xtest=x;
ii=0;
tt=0;

absorb=0;
while tt < tmax & ii < NN & absorb < 1 
ii=ii+1;
if mod(ii,50000)==0
ii
end

% calculer les densites de proba des reactions
a=[k1*x(1)^nu,k2*x(3)*x(2),k3*x(4)*x(2),k4*x(4),k5*x(1)];
am=[km1*x(2),km2*x(4),km3*(D0-x(3)-x(4))];
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
if tot>0.0
u=rand(1);
cum=0;
i=0;
while cum < u
i=i+1;
cum=cum+aa(i)/tot;
end
% activer la reaction i, calculer l'etat
signe=1;
if i>5
   i=i-5;
   signe=-1;
end
for j=1:4
	xtest(j)=x(j)+signe*saut(i,j);
end
%%% reaction effective seulement si l'etat suivant est dans N^4
if xtest(1)>-0.1 & xtest(2)>-0.1 & xtest(3)>-0.1 & xtest(4)>-0.1
x=xtest;
end

end %% if tot

if x(1)<0.1 & x(2)<0.1 & x(4) < 0.1
absorb=1
nabs=nabs+1;
end
%%%%%%%%%%%%
x1(ii)=x(1);x2(ii)=x(2);x3(ii)=x(3);x4(ii)=x(4);

end %%% while tt

if figures == 1
subplot(2,2,1)
if iii==1
hold off
end
plot(time(1:ii),x1(1:ii)/scale)
hold on

subplot(2,2,2)
if iii==1
hold off
end
plot(time(1:ii),x2(1:ii)/scale,'r')

hold on

subplot(2,2,3)
if iii==1
hold off
end  
plot(time(1:ii),x3(1:ii)/scale);hold on; 


subplot(2,2,4)
if iii==1
hold off
end 
plot(time(1:ii),x4(1:ii)/scale,'r');hold on;

end % if

if absorb==1
t2abs(iii)=time(ii);
t2abs(iii)
else
t2abs(iii)=tmax;
end

end %% monte carlo

%%%%%%%%%% integrer systeme differentiel
xo=etat0';to=0;tf=tmax;
oldoptions=odeset;
options=odeset(oldoptions,'RelTol',1e-6,'Refine',1);
[t,x]=ode23t('dynbis',[to tf],xo,options);

if figures == 1
subplot(2,2,1)
plot(t,x(:,1)/scale,'g.');
plot([0 tmax],[xx(1),xx(1)]/scale)
plot([0 tmax],[xx(2),xx(2)]/scale)
axis([0, tmax ,-0.1*X0/scale, 2*xx(2)/scale]);
ylabel('X')
xlabel('temps')

subplot(2,2,2)
plot(t,x(:,2)/scale,'c.')
plot([0 tmax],[xn(1),xn(1)]/scale)
plot([0 tmax],[xn(2),xn(2)]/scale)
axis([0, tmax ,-0.1*X0/scale, 2*xn(2)/scale]);
ylabel('X_\nu')
xlabel('temps')

subplot(2,2,3)
plot(t,x(:,3)/scale,'g.');
plot([0 tmax],[d(1),d(1)]/scale)
plot([0 tmax],[d(2),d(2)]/scale)
axis([0, tmax ,-0.1*D0/scale, 1.2*D0/scale]);
ylabel('D')
xlabel('temps')

subplot(2,2,4)
plot(t,x(:,4)/scale,'c.');  
plot([0 tmax],[d1(1),d1(1)]/scale)
plot([0 tmax],[d1(2),d1(2)]/scale)
axis([0, tmax ,-0.1*D0/scale, 1.2*D0/scale]);
ylabel('D_1')
xlabel('temps')
title(cat(2,'mc= ',cat(2,num2str(mc),cat(2,' k1= ',cat(2,num2str(k1),cat(2,' k2= ',num2str(k2)))))))

end % if

probabs(ipar)=nabs/mc;
%%% distribution des temps de sortie
nbins=100;
[eff,val]=hist(t2abs,nbins);
binwidth=mean(diff(val));
eff=eff/(mc);
frep=cumsum(eff);
ind=find(eff>0);
x=val(ind);
y=log(eff(ind));
a=polyfit(x,y,1)

if figures == 1
figure(3)
subplot(2,1,1)
hold off
bar(val,eff/binwidth,'histc')
hold on
subplot(2,1,2)
hold off
plot(x,y,'x')
hold on
plot(x,a(1)*x+a(2))
end % if
%%% temps moyen
tmoy1(ipar)=-1/a(1);
%%% calcul du temps moyen + erreur par montecarlo
tmoy2(ipar)=mean(t2abs);
lambda=1/tmoy2(ipar);
err(ipar)=1.96*std(t2abs)/sqrt(mc);
fth=1-exp(-val*lambda);
kolmo(ipar)=max(abs(fth-frep))*sqrt(mc)

if figures == 1 
subplot(2,1,1)
plot(val,exp(-val*lambda)*lambda,'r')
figure(4)
hold off
plot(val,frep)
hold on
plot(val,fth,'r')
end % if

table=cat(2,tmoy1,cat(2,tmoy2,cat(2,err,cat(2,kolmo,probabs))));
if record==1
save table3.txt table -ascii
end
end % ipar
figure(5)
t=load('table2.txt');
x=2*(1:5);
y=t(:,2);
e=t(:,3);
%%% fit par y=exp(a(2)+a(1)*x) pour les temps longs (faible bruit)
a=polyfit((x'),log(y),1);
hold off
plot(x,y+e,'x')
hold on
plot(x,y-e,'x')
plot(x,exp(a(2)+a(1)*(x)),'r')
xlabel('volume')
ylabel('Temps de sortie')


return
figure(5)
load table.txt, load table1.txt, t=cat(1,table,table1);
x=2:2:26;
y=t(:,2);
e=t(:,3);
%%% fit par y=exp(a(2)+a(1)*x) pour les temps longs (faible bruit)
a=polyfit((x(10:13)'),log(y(10:13)),1);
hold off
plot(x,y+e,'x')
hold on
plot(x,y-e,'x')
plot(x,exp(a(2)+a(1)*(x)),'r')
%plot(x,0.0312*exp(0.39*(x)),'g')
%% fit par y=exp(a(2)+a(1)*x^0.25) pour les temps courts (bruit important)
p=0.25;
a=polyfit((x(1:8)').^p,log(y(1:8)),1);
plot(x(1:8),exp(a(2)+a(1)*(x(1:8)).^p),'b')
xlabel('Volume')
ylabel('Temps de sortie')


