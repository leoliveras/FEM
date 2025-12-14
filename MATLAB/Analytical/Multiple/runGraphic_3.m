clear; clc;

% === Leitura do arquivo Caminhos_estabilidade.txt ===
fid = fopen('equilibrium_path.txt', 'r');

% Lê os dados: x1, x2, lambda, autovalor1, autovalor2, estado
data = textscan(fid, '%f %f %f %f %f %s');
fclose(fid);

x1 = data{1};
x2 = data{2};
lambda= data{3}
estados = data{6};

% Separa estáveis e instáveis
idx_estavel = strcmp(estados, 'estável');
idx_instavel = strcmp(estados, 'instável');

% === Plot ===
% === Plotagem em subplots separados ===
figure;

%% --- Subplot 1: lambda vs chi1 ---
subplot(3,1,1);
hold on;
plot(x1(idx_estavel), lambda(idx_estavel), 'go', 'DisplayName', 'Estável');
plot(x1(idx_instavel), lambda(idx_instavel), 'ro', 'DisplayName', 'Instável');
xlabel('\chi_1');
ylabel('\lambda');
title('Análise de Estabilidade: \lambda vs \chi_1');
legend('Location', 'best');
grid on;

% Escala automática com margem
y1 = lambda;
ymin = min(y1);
ymax = max(y1);
padding = 0.05 * (ymax - ymin);
ylim([ymin - padding, ymax + padding]);
xlim([0, 2]);

pbaspect([2 1 1])  % eixo x: 1, eixo y: 2, eixo z: 1 (no 2D, z é ignorado)


%% --- Subplot 2: lambda vs chi2 ---
subplot(3,1,2);
hold on;
plot(x2(idx_estavel), lambda(idx_estavel), 'go', 'DisplayName', 'Estável');
plot(x2(idx_instavel), lambda(idx_instavel), 'ro', 'DisplayName', 'Instável');
xlabel('\chi_2');
ylabel('\lambda');
title('Análise de Estabilidade: \lambda vs \chi_2');
legend('Location', 'best');
grid on;

% Escala automática com margem
y2 = lambda;
ymin = min(y2);
ymax = max(y2);
padding = 0.05 * (ymax - ymin);
ylim([ymin - padding, ymax + padding]);
xlim([0, 2]);

pbaspect([2 1 1])  % eixo x: 1, eixo y: 2, eixo z: 1 (no 2D, z é ignorado)


%% --- Subplot 3: chi2 vs chi1 ---
subplot(3,1,3);
hold on;
plot(x1(idx_estavel), x2(idx_estavel), 'go', 'DisplayName', 'Estável');
plot(x1(idx_instavel), x2(idx_instavel), 'ro', 'DisplayName', 'Instável');
xlabel('\chi_1');
ylabel('\chi_2');
xlim([0, 2]);
title('Estabilidade: \chi_2 vs \chi_1');
legend('Location', 'best');
grid on;  % mais apropriado que axis equal aqui
axis tight;
pbaspect([2 1 1])  % eixo x: 1, eixo y: 2, eixo z: 1 (no 2D, z é ignorado)