syms x1 x2 lambda delta1 delta2 k real

% Parâmetros fixos
delta1_val = 0.08;
delta2_val = 0.08;
k_val = 0.005;

% Equações (transcrição fiel de eq1 e eq2)
A1 = (-x1*delta1_val + delta1_val);
B1 = sqrt(1 + (delta1_val^2));
C1 = sqrt(1 + A1^2);
eq1 = k_val*(x1*delta1_val - x2*delta2_val)*delta1_val ...
         - 2 * ((C1 - B1) * A1 * delta1_val) / (B1^2 * C1) ...
         - lambda * delta1_val;

% === eq2: dPi/dx2 ===
A2 = (-x2*delta2_val + delta2_val);
B2 = sqrt(1 + (delta2_val^2));
C2 = sqrt(1 + A2^2);
eq2 = -k_val*(x1*delta1_val - x2*delta2_val)*delta2_val ...
         - 2 * ((C2 - B2) * A2 * delta2_val) / (B2^2 * C2);

% Sistema simbólico
Fsym = [eq1; eq2];
Vars = [x2; lambda];

% Conversão para função numérica (x1 como parâmetro)
Ffun = matlabFunction(Fsym, 'Vars', {x1, Vars, delta1, delta2, k});
Jfun = matlabFunction(jacobian(Fsym, Vars), 'Vars', {x1, Vars, delta1, delta2, k});

% Parâmetros de Newton
max_iter = 30;
tol = 1e-8;

% Faixa de x1
x1_vals = 0:0.01:2.29;
n = length(x1_vals);
L = zeros(n, 3);  % salvar: [x1, x2, lambda]

% Loop principal
for j = 1:n
    x1_val = x1_vals(j);
    
    % chute inicial para [x2, lambda]
    W = [0.0; 0.0];

    for iter = 1:max_iter
        F_val = Ffun(x1_val, W, delta1_val, delta2_val, k_val);
        J_val = Jfun(x1_val, W, delta1_val, delta2_val, k_val);
        
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
    fprintf(fid, '%.1f %.10f %.10f\n', L(k,1), L(k,2), L(k,3));
end
fclose(fid);