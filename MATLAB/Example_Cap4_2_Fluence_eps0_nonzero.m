format long g
            % barra 1-2                  barra 1-3               barra 1-4
sigma11 = 0.137240584357110E+01; % 0.234344771402235E+01   0.306673404551072E+01  1 increment
sigma12 = 0.164688701220689E+01; % 0.281213725669289E+01   0.368008085443761E+01  2 increment
sigma13 = 0.192136818102344E+01; % 0.328082679967211E+01   0.429342766376844E+01        ... 
sigma14 = 0.219584934973766E+01; % 0.374951634247658E+01   0.490677447287058E+01        ...
sigma15 = 0.247033051845188E+01; % 0.421820588528105E+01   0.552012128197272E+01        ... 
sigma16 = 0.260757110280899E+01; % 0.445255065668328E+01   0.582679468652380E+01        ...
sigma17 = 0.274481168715415E+01; % 0.468689542806510E+01   0.613346809102144E+01  last increment
%sigma = [sigma11, sigma12,sigma 13, sigma 14, sigma 15, sigma 16, sigma17);
E = 2000; 
E0 = 2000;
E1 = 2000; 
eta = 2e-3; 
creps=E1/(E0+E1);
T = 3.5;

% solução analítica
eps_ve_fun1 = @(t) sigma11/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun2 = @(t) (sigma12-sigma11)/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun3 = @(t) (sigma13-sigma12)/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun4 = @(t) (sigma14-sigma13)/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun5 = @(t) (sigma15-sigma14)/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun6 = @(t) (sigma16-sigma15)/E0 * (1 - creps * exp(-eta * E0 * creps * t));
eps_ve_fun7 = @(t) (sigma17-sigma16)/E0 * (1 - creps * exp(-eta * E0 * creps * t));

% solução derivada da analítica
deps_ve_fun1 = @(t) sigma11 * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun2 = @(t) (sigma12-sigma11) * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun3 = @(t) (sigma13-sigma12) * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun4 = @(t) (sigma14-sigma13) * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun5 = @(t) (sigma15-sigma14) * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun6 = @(t) (sigma16-sigma15) * eta * creps^2 .* exp(-eta * E0 * creps * t);
deps_ve_fun7 = @(t) (sigma17-sigma16) * eta * creps^2 .* exp(-eta * E0 * creps * t);

% componente elástica instantânea
eps_e11 = sigma11 / E;
eps_e12 = (sigma12-sigma11) / E;
eps_e13 = (sigma13-sigma12) / E;
eps_e14 = (sigma14-sigma13) / E;
eps_e15 = (sigma15-sigma14) / E;
eps_e16 = (sigma16-sigma15) / E;
eps_e17 = (sigma17-sigma16) / E;
eps = sigma12 / E;



% componente viscoelástica instantânea e apos ensaio
x11 = eps_ve_fun1(0);
x12 = eps_ve_fun1(T);

x21 = eps_ve_fun2(0) + x12;
x22 = eps_ve_fun2(T) + x12;

x31 = eps_ve_fun3(0) + x22; 
x32 = eps_ve_fun3(T) + x22;

x41 = eps_ve_fun4(0) + x32;
x42 = eps_ve_fun4(T) + x32;

x51 = eps_ve_fun5(0) + x42;
x52 = eps_ve_fun5(T) + x42;

x61 = eps_ve_fun6(0) + x52;
x62 = eps_ve_fun6(T) + x52;

x71 = eps_ve_fun7(0) + x62;
x72 = eps_ve_fun7(T) + x62;


I1 = integral(deps_ve_fun1, 0, T) ;
I2 = integral(deps_ve_fun2, 0, T) ;
I3 = integral(deps_ve_fun3, 0, T) ;
I4 = integral(deps_ve_fun4, 0, T) ;
I5 = integral(deps_ve_fun5, 0, T) ;
I6 = integral(deps_ve_fun6, 0, T) ;
I7 = integral(deps_ve_fun7, 0, T) ;

% Teste integral
eps11a = eps_e11 + eps_ve_fun1(0) + I1 ;
eps12a = eps_e12 + eps_ve_fun2(0) + I2 ;
eps13a = eps_e13 + eps_ve_fun3(0) + I3 ;
eps14a = eps_e14 + eps_ve_fun4(0) + I4 ;
eps15a = eps_e15 + eps_ve_fun5(0) + I5 ;
eps16a = eps_e16 + eps_ve_fun6(0) + I6 ;
eps17a = eps_e17 + eps_ve_fun7(0) + I7 ;

eps_eTotal_a = eps_e11 + eps_e12 + eps_e13 + eps_e14 + eps_e15 + eps_e16 + eps_e17;
epsTotal_a = eps11a + eps12a + eps13a + eps14a + eps15a + eps16a + eps17a;

% Teste derivada
eps11b = eps_e11 + eps_ve_fun1(T);
eps12b = eps_e12 + eps_ve_fun2(T);
eps13b = eps_e13 + eps_ve_fun3(T);
eps14b = eps_e14 + eps_ve_fun4(T);
eps15b = eps_e15 + eps_ve_fun5(T);
eps16b = eps_e16 + eps_ve_fun6(T);
eps17b = eps_e17 + eps_ve_fun7(T);

epsTotal_b = eps11b + eps12b + eps13b + eps14b + eps15b + eps16b + eps17b

eps2= x21 + eps_e11 + eps_e12


% --- Incremento 1 ---
t1 = linspace(0, T, 2000);
eps11b = @(t1) eps_e11 + eps_ve_fun1(t1);
eps11bF = eps_e11 + eps_ve_fun1(T);

% --- Incremento 2 ---
t2 = linspace(0, T, 2000);
eps12b = @(t2) eps11bF + eps_e12 + eps_ve_fun2(t2);
eps12bF = eps_e12 + eps_ve_fun2(T);

% --- Incremento 3 ---
t3 = linspace(0, T, 2000);
eps13b = @(t3) eps11bF + eps12bF + eps_e13 + eps_ve_fun3(t3);
eps13bF = eps_e13 + eps_ve_fun3(T);

% --- Incremento 4 ---
t4 = linspace(0, T, 2000);
eps14b = @(t4) eps11bF + eps12bF + eps13bF + eps_e14 + eps_ve_fun4(t4);
eps14bF = eps_e14 + eps_ve_fun4(T);

% --- Incremento 5 ---
t5 = linspace(0, T, 2000);
eps15b = @(t5) eps11bF + eps12bF + eps13bF + eps14bF + eps_e15 + eps_ve_fun5(t5);
eps15bF = eps_e15 + eps_ve_fun5(T);

% --- Incremento 6 ---
t6 = linspace(0, T, 2000);
eps16b = @(t6) eps11bF + eps12bF + eps13bF + eps14bF + eps15bF + eps_e16 + eps_ve_fun6(t6);
eps16bF = eps_e16 + eps_ve_fun6(T);

% --- Incremento 7 ---
t7 = linspace(0, T, 2000);
eps17b = @(t7) eps11bF + eps12bF + eps13bF + eps14bF + eps15bF + eps16bF + eps_e17 + eps_ve_fun7(t7);
eps17bF = eps_e17 + eps_ve_fun7(T);

% ------------------ PLOT ------------------
figure;
set(gcf, 'Color', 'w');   % <-- fundo branco da janela inteira
hold on; 
grid on;

plot(t1,            eps11b(t1), 'LineWidth', 2)
plot(t2 + T,        eps12b(t2), 'LineWidth', 2)
plot(t3 + 2*T,      eps13b(t3), 'LineWidth', 2)
plot(t4 + 3*T,      eps14b(t4), 'LineWidth', 2)
plot(t5 + 4*T,      eps15b(t5), 'LineWidth', 2)
plot(t6 + 5*T,      eps16b(t6), 'LineWidth', 2)
plot(t7 + 6*T,      eps17b(t7), 'LineWidth', 2)

% Conectar fim do incremento 1 com início do 2
plot([T, T], [eps11bF, eps12b(0)], '--k')

% Conectar fim do incremento 2 com início do 3
plot([2*T, 2*T], [eps12bF + eps11bF, eps13b(0)], '--k')

% Conectar fim do incremento 3 com início do 4
plot([3*T, 3*T], [eps13bF + eps12bF + eps11bF, eps14b(0)], '--k')

% Conectar fim do incremento 4 com início do 5
plot([4*T, 4*T], [eps14bF + eps13bF + eps12bF + eps11bF, eps15b(0)], '--k')

% Conectar fim do incremento 5 com início do 6
plot([5*T, 5*T], [eps15bF + eps14bF + eps13bF + eps12bF + eps11bF, eps16b(0)], '--k')

% Conectar fim do incremento 6 com início do 7
plot([6*T, 6*T], [eps16bF + eps15bF + eps14bF + eps13bF + eps12bF + eps11bF, eps17b(0)], '--k')


xlabel('t (s)')
ylabel('\epsilon(t) = \epsilon_{e} + \epsilon_{ve}(t)')
title('Componentes elásticas e viscoelásticas por incremento')
grid on



