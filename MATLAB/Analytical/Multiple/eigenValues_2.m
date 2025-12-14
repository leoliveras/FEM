clear; clc; 

%% === Leitura dos dados ===
data = readmatrix('path.txt');
x1_vals = data(:,1);
x2_vals = data(:,2);
lambda_vals = data(:,3);
n = size(data, 1);

%% === Definir função Pi e calcular Hessiana ===
syms x1 x2 lambda delta1 delta2 k real

term1 = (k/2) * (x1*delta1 - x2*delta2)^2;

term2 = ( ( sqrt(1 + (delta1 - x1*delta1)^2) - sqrt(1 + delta1^2) ) / sqrt(1 + delta1^2) )^2;

term3 = ( ( sqrt(1 + (delta2 - x2*delta2)^2) - sqrt(1 + delta2^2) ) / sqrt(1 + delta2^2) )^2;

term4 = lambda * x1 * delta1;

Pi = term1 + term2 + term3 - term4;

% Hessiana de Pi em relação a [x1, x2]
H = hessian(Pi, [x1, x2]);

% Converte para função numérica rápida
Hfun = matlabFunction(H, 'Vars', {x1, x2, lambda, delta1, delta2, k});

%% === Parâmetros fixos ===
delta1_val = 0.08;
delta2_val = 0.08;
k_val = 0.005;

%% === Avaliação e escrita no arquivo ===
fid2 = fopen('equilibrium_path.txt', 'w');

for i = 1:n
    x1i = x1_vals(i);
    x2i = x2_vals(i);
    lambdai = lambda_vals(i);
    
    % Avalia a Hessiana
    FQ = Hfun(x1i, x2i, lambdai, delta1_val, delta2_val, k_val);
    
    % Autovalores
    A = eig(FQ);
    
    % Avalia estabilidade
    if all(A > 0)
        est = "estável";
    else
        est = "instável";
    end

    % Escreve no arquivo
    fprintf(fid2, '%.1f %.10f %.10f %.2f %.2f %s\n', ...
        x1i, x2i, lambdai, A(1), A(2), est);
end

fclose(fid2);