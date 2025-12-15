function [disp1, load1] = graphicRead(filename)
    % Lê dados de deslocamento x carga exportados do Abaqus (.txt)

    % Caminho do arquivo exportado (ex: 'vonMisesTruss_loaddisp.txt')
    dispfile = [filename, '_loaddisp.txt'];

    % Lê o arquivo ignorando as 2 primeiras linhas de cabeçalho
    DATA_Disp = importdata(dispfile, ' ', 2);

    % Extrai as colunas (1 = deslocamento, 2 = carga)
    disp1 = DATA_Disp.data(:, 1);
    load1 = DATA_Disp.data(:, 2);
end