function [disp1, load1] = readHistoryOdb(filename)
% Executa o script Python gerado pelo Abaqus e importa a curva Load x Disp
%
% Entrada:
%   filename - nome base do arquivo (sem extensão)
%
% Saída:
%   disp1 - vetor de deslocamentos
%   load1 - vetor de forças

    % Nome do script Python
    FileName_Py = ['readHistoryOdb_', filename, '.py'];
    FullPath_Py = fullfile(FileName_Py);

    % Executa o script Python via Abaqus (modo sem GUI)
    cmd = sprintf('abaqus cae noGUI=%s', FullPath_Py);
    system(cmd);

    % Arquivo de saída gerado
    dispfile = [filename, '_loaddisp.txt'];

    % Importa os dados do arquivo texto
    DATA_Disp = importdata(dispfile, ' ', 2); % ignora as 2 primeiras linhas do header
    disp1 = DATA_Disp.data(:, 1);
    load1 = DATA_Disp.data(:, 2);
end
