syms x1 x2 lambda delta1 delta2 k real

% Parâmetros fixos
delta1_val = 0.08;
k_val = 0.000;

% Equation
A1 = (-x1*delta1_val + delta1_val);
B1 = sqrt(1 + (delta1_val^2));
C1 = sqrt(1 + A1^2);
eq1 = k_val*(x1*delta1_val)*delta1_val ...
     -2 * ((C1 - B1) * A1 * delta1_val) / (B1^2 * C1) ...
     -lambda * delta1_val;


% Sistema simbólico
Fsym = [eq1];
Vars = [lambda];

% Conversão para função numérica (x1 como parâmetro)
Ffun = matlabFunction(Fsym, 'Vars', {x1, Vars, delta1, delta2, k});
Jfun = matlabFunction(jacobian(Fsym, Vars), 'Vars', {x1, Vars, delta1, k});

% Parâmetros de Newton
max_iter = 30;
tol = 1e-8;

% Faixa de x1
x1_vals = 0:0.01:2.29;
n = length(x1_vals);
L = zeros(n, 2);  % salvar: [x1, lambda]

% Loop principal
for j = 1:n
    x1_val = x1_vals(j);
    
    % chute inicial para [lambda]
    W = [0.0];

    for iter = 1:max_iter
        F_val = Ffun(x1_val, W, delta1_val, k_val);
        J_val = Jfun(x1_val, W, delta1_val, k_val);
        
        deltaW = -J_val \ F_val;
        W = W + deltaW;

        if norm(deltaW) < tol
            break;
        end
    end

    % Armazenar [x1, x2, lambda]
    L(j, :) = [x1_val, W.'];
end

% Escrever em arquivo
fid = fopen('path.txt', 'w');
for k = 1:n
    fprintf(fid, '%.1f %.10f\n', L(k,1), L(k,2));
end

fclose(fid);
