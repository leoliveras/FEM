format long g

sigma1 = 1.37240584357110;   % fist increment
sigma2 = 2.34344771402235;   % fist increment   
sigma3 = 6.13349743384465;   % last increment
sigma = sigma2;
E = 2000; 
E0 = 2000;
E1 = 2000; 
eta = 2e3; 

% solução analítica
eps_ve_fun = @(t) (sigma/E0).*(1 - exp(-t*eta/E0));

% derivada da analítica
deps_ve_fun = @(t) (sigma*eta/E0^2) .* exp(-t*eta/E0);

% componente elástica instantânea
eps_e = sigma / E;

T = 100000;

x1 = eps_ve_fun(0)
x2 = eps_ve_fun(T)

I = integral(deps_ve_fun, 0, T);

eps1a = eps_e + I;

eps1b = eps_e + eps_ve_fun(T)

eps2= eps_e + 0.3066587469696074961384E-02

