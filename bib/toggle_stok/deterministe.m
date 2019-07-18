function xp=deterministe(t,x);
global m;
xp=m*reaction(x)-m*reaction_reverse(x);
