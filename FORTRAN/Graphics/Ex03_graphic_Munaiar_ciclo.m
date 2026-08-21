function PLOT_RESULT()
% PLOT_RESULT
% Compara o caminho de equilíbrio obtido pelo
% OWEN modificado e pelo ABAQUS.
%
% Cada arquivo deve conter:
%   coluna 1: força/reação
%   coluna 2: deslocamento

    ARQUIVO_OWEN   = 'saida_Munaiar_ciclo1.txt';
    ARQUIVO_ABAQUS = 'saida_ABAQUS_Munaiar_ciclo1.txt';

    %% ============================================================
    %  LEITURA - OWEN
    %  MODIFICADO1zsZsss1qzqzqaZAZZQAZ2QAZ22222222222222222222222222QAZ2QAZQAZ2AZ2QAZ2Z2SX2XSWWSX2WSXSSX\\2SX==================================

    if ~isfile(ARQUIVO_OWEN)
        error('O arquivo "%s" não foi encontrado na pasta:\n%s', ...
              ARQUIVO_OWEN, pwd);
    end

    DADOS_OWEN = readmatrix(ARQUIVO_OWEN);

    if size(DADOS_OWEN,2) < 2
        error('O arquivo "%s" precisa possuir pelo menos duas colunas.', ...
              ARQUIVO_OWEN);
    end

    DADOS_OWEN = DADOS_OWEN(:,1:2);
    DADOS_OWEN = DADOS_OWEN(all(isfinite(DADOS_OWEN),2),:);

    FORCA_OWEN = DADOS_OWEN(:,1);
    DESLOCAMENTO_OWEN = DADOS_OWEN(:,2);


    %% ============================================================
    %  LEITURA - ABAQUS
    % ============================================================

    if ~isfile(ARQUIVO_ABAQUS)
        error('O arquivo "%s" não foi encontrado na pasta:\n%s', ...
              ARQUIVO_ABAQUS, pwd);
    end

    DADOS_ABAQUS = readmatrix(ARQUIVO_ABAQUS);

    if size(DADOS_ABAQUS,2) < 2
        error('O arquivo "%s" precisa possuir pelo menos duas colunas.', ...
              ARQUIVO_ABAQUS);
    end

    DADOS_ABAQUS = DADOS_ABAQUS(:,1:2);
    DADOS_ABAQUS = DADOS_ABAQUS(all(isfinite(DADOS_ABAQUS),2),:);

    FORCA_ABAQUS = DADOS_ABAQUS(:,1);
    DESLOCAMENTO_ABAQUS = DADOS_ABAQUS(:,2);


    %% ============================================================
    %  GRÁFICO
    % ============================================================

    figure;
    hold on;

    % OWEN modificado - bolinhas
    plot(DESLOCAMENTO_OWEN, FORCA_OWEN, 'o', ...
         'LineStyle', 'none', ...
         'MarkerSize', 6);

    % ABAQUS - linha cheia
    plot(DESLOCAMENTO_ABAQUS, FORCA_ABAQUS, '-', ...
         'LineWidth', 1.5);

    grid on;
    box on;

    xlabel('Deslocamento');
    ylabel('Força');
    title('Caminho de equilíbrio');

    legend('OWEN modificado', 'ABAQUS', ...
           'Location', 'best');

    hold off;

end