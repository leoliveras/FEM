format long g

sigma1 = 1.37240584357110;   % fist increment
sigma2 = 2.34344771402235;   % fist increment   
sigma3 = 6.13349743384465;   % last increment
sigma = sigma1;
E = 2000; 
E0 = 2000;
E1 = 2000; 
eta = 2e-3; 
creps=E1/(E0+E1);

% solução analítica
eps_ve_fun = @(t) (sigma./E0) .* (1 - exp(-eta .* E0 .* creps .* t));

% solução derivada da analítica

deps_ve_fun = @(t) sigma .* eta .* E0 .* creps ./ E0 .* exp(-eta .* E0 .* creps .* t);

% componente elástica instantânea
eps_e = sigma / E;

T = 10000;

x1 = eps_ve_fun(0)
x2 = eps_ve_fun(T)

I = integral(deps_ve_fun, 0, T);

eps1a = eps_e + I + eps_ve_fun(0);

eps1b = eps_e + eps_ve_fun(T)

eps2= eps_e + 0.6410312149009185890905E-03


