global m k1 k2 k3 k4 k5 km1 km2 km3 nu n_reactions;

n_produits=5;
n_reactions=5;
% parametres stoechiometriques
nu=2;n=5;
%%%%%%%%%%%%%%%%%%%%%%%
% parametres cinétiques
%%%%%%%%%%%%%%%%%%%%%%%
%%% fixe echelle parametre d'ordre X=amp et 0 aux attracteurs
amp=1;
beta=(amp)^(-nu);
chi1=sqrt(beta);
chi2=chi1;
sigma=1;
alpha=(2+sigma)*beta^(1-1/nu);
chi3=chi2;
%%% fixe echelle parametre d'orde D
D0=amp/4;
% fixer des echelles de temps
k1=0.05; %formation heterodimere
k2=0.05; %adhesion site
k3=0.05; %blockage
k5=0.01; %degradation
km1=k1/chi1;
km2=k2/chi2;
km3=k3/chi3;
k4=k5*alpha/(n*beta*D0); %% K4,k5 a peu pres meme ordre de gradeur
%%%%%%%%%%%%%%%%%%%%%%%%
m=zeros(n_produits,n_reactions);
%matrice stoechiometrique
m=[-nu,1,0,0,0;0,-1,-1,1,0;0,-1,0,-1,1;n,0,0,0,0;-1,0,0,0,0]';
%   --- Condition initiale
x0=zeros(1,n_produits); %Initial condition set to zero for each molecule
x0(1)=2*amp; % facteur transcription initial
x0(1)=3*amp;
x0(3)=D0; % sites promoteurs initials
t0=0;
tmax=800;
%   --- Solveur deterministe
[T,X]=ode23tb('deterministe',[t0, tmax],x0);


% Visualiser solution
figure(1)
hold off
subplot(2,2,1)
hold off;
plot(T,X(:,1)); hold on;
grid on;
xlabel('temps');
ylabel('X');
subplot(2,2,2)
hold off;
plot(T,X(:,2));hold on;
grid on;
xlabel('temps');
ylabel('X_\nu');
subplot(2,2,3)
hold off;
plot(T,X(:,3));hold on;
grid on;
xlabel('temps');
ylabel('D');
subplot(2,2,4)
hold off;
plot(T,X(:,4));hold on;
grid on;
xlabel('temps');
ylabel('D_1');


%   --- Solveur stochastique
rand('state',sum(100*clock)); %% intialiser generateur no aleatoires
time=t0;
nmax=1000; %imposer un nombre max de reactions 
volume=10/D0   ; %%% choisir un volume (ici pour avoir un seul site promoteur/cellule)
state=round(x0*volume); %%% calculer vecteur nombre de particules
state_test=state;
x=x0;
n_react=0;
while time < tmax & n_react < nmax
    preact=volume*reaction(x); %%% reactions / unite de temps
    preact_rev=volume*reaction_reverse(x); %%% reactions reverse / unite de temps
    tot=sum(preact)+sum(preact_rev);
    aa=cat(1,preact,preact_rev); %%% concatener les taux, mettre les reactions inverses dans 2-eme partie
    if tot>0.0
        tau=-log(rand(1))/tot; %%% temps entre reactions
        %%%% choix reaction
        u=rand(1);
        cum=0;
        i=0;
        while cum<u
            i=i+1;
            cum=cum+aa(i)/tot;
        end %%% choix reaction   
        if i>n_reactions
            signe=-1;
            i=i-n_reactions;
        else
            signe=1;
        end; 
        %%% verifier que la transition est possible
        test=1;
        state_test=state;
        for j=1:n_produits
            state_test(j)=state_test(j)+signe*m(j,i); %%% changer etat (vecteur no particules)
            if state_test(j)<0 
                test=0;
            end
        end
        if test==1
            time=time+tau; %%% incrementer temps
            n_react=n_react+1;
            state=state_test;
            x=state/volume;  %%% changer vecteur concentrations
                    [i,signe]
        end
        subplot(2,2,1);
        plot([time,time],[x(1),x(1)],'.');
        subplot(2,2,2);
        plot([time,time],[x(2),x(2)],'.');
        subplot(2,2,3);
        plot([time,time],[x(3),x(3)],'.');
        subplot(2,2,4);
        plot([time,time],[x(4),x(4)],'.');
    else
        time=tmax;
    end     
end % while    


