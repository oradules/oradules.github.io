function v=reaction(x);
global k1 k2 k3 k4 k5 nu n_reactions;

v=zeros(n_reactions,1);

v(1)=k1*x(1)^nu;
v(2)=k2*x(2)*x(3);
v(3)=k3*x(2)*x(4);
v(4)=k4*x(4);
v(5)=k5*x(1);
