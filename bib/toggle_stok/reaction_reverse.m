function v=reaction_reverse(x);
global km1 km2 km3 n_reactions;

v=zeros(n_reactions,1);

v(1)=km1*x(2);
v(2)=km2*x(4);
v(3)=km3*x(5);


