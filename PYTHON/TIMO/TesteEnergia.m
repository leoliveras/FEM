clear; clc;

syms E G A I L q0 k x y
syms v(x) phi(x)
syms C1 C2 C3 C4

%% Sistema de Timoshenko (forte)

eq1 =  diff(k*G*A*(diff(v,x) + phi), x) + q0 == 0;
eq2 =  E*I*diff(phi,x,2) - k*G*A*(diff(v,x) + phi) == 0;


%% Resolver sistema acoplado
sol = dsolve([eq1, eq2]);

phi(x)   = sol.phi;
v(x) = sol.v;


%% Condições de contorno físicas corretas
eqs = [
    subs(v,x,0) == 0
    subs(v,x,L) == 0
    subs(diff(phi,x),x,0) == 0  % M = EI*phi' = 0 ⇒ phi livre ou momento definido
    subs(diff(phi,x),x,L) == 0
];

vars = [C1 C2 C3 C4];

%% Troca solve por vpasolve (muito mais rápido)
consts = solve(eqs, vars);

%% Substituir constantes
v   = subs(v, consts);
phi = subs(phi, consts);
sigma = E*y*diff(phi,x);
gamma = phi + diff(v,x);
tau = k*G*gamma;

disp(v)
disp(phi)
disp(sigma)
disp(tau)




%% Energia potencial total
Pi = int( ...
    (E*I*(diff(phi,x))^2)/2 + ...
    (k*G*A*(phi + diff(v,x))^2)/2 - ...
    q0*v, x, 0, L);

Pi_val = subs(Pi, ...
    [E A G I k q0 L], ...
    [200e9 50e-6 77e9 1e-6 5/6 10 4]);

disp('Pi = ')
double(Pi_val)

99