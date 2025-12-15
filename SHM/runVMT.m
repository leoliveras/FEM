%% ======================================================================== 
%                  Complete script for von Mises truss
%% ========================================================================    

clear; clc;

%% ====================  Create model parameters  ========================= 
% 1️⃣ Model parameters

JobName1 = 'VMTRS_job1';
JobName2 = 'VMTRS_job2';
numCPU = 1;

% User and Work Folders
inputFolder = 'C:\Users\LOESF\OneDrive\Documents\Truss_Element\ML\TESTE\MATLAB';   
tempFolder  = 'C:\temp';  %this is the work Folder used by abaqus

if ~exist(inputFolder,'dir'); mkdir(inputFolder); end
if ~exist(tempFolder,'dir'); mkdir(tempFolder); end

% 2️⃣ Mesh definition
mesh.nodes = [ ...
    1, -12.5, 0.0;
    2,  0.0,  1.0;
    3, 12.5,  0.0];

mesh.LNODS = [ ...
    1, 1, 2;
    2, 2, 3];


fixedNodes = [1,3];
rollerNodes = [];     % no rollers
loadNodes  = [2];
%loadNodesAdd = [0];
loaddirection = 2;
loadValue = [-10000];

% 3️⃣ Generate .inp
VMTinpfileconstrarch(JobName1, mesh, loadNodes, loadValue, fixedNodes, loaddirection)
inpFile1 = fullfile(inputFolder, [JobName1, '.inp']);
VMTinpfileconstrarch(JobName2, mesh, loadNodes, -loadValue, fixedNodes, loaddirection)
inpFile2 = fullfile(inputFolder, [JobName2, '.inp']);

%if ~exist(inpFile1,'file') && ~exist(inpFile2,'file')
%    error('Erro: arquivo .inp não encontrado em %s e %s', inpFile1, inpFile2);
%else
%    fprintf('✅ Arquivos gerado com sucesso:\n%s\n%s\n', inpFile1, inpFile2);
%end

copyfile(inpFile1, tempFolder);
copyfile(inpFile2, tempFolder);


%% =================  Submit & Monitor & Analysis ========================= 
% 4️⃣ Submit job1 to abaqus
cd(tempFolder); 

%cmd = sprintf('abaqus job=%s input="%s" cpus=%d interactive', JobName, inpFileTemp, numCPU); ---> only for CAE (Graphic windows)  

cmd = sprintf('abaqus job=%s input="%s" cpus=%d', JobName1, inpFile1, numCPU);
disp(['Submetendo job1: ', cmd]);
status1 = system(cmd);

if status1 == 0
    disp('Job1 submetido com sucesso!');
else
    disp('Erro ao submeter o job.');
end

%% ====================== Monitor & Analysis ============================== 
% 5️⃣ Abaqus job1 and job2 monitoring

%cmd = sprintf('abaqus job=%s input="%s" cpus=%d', JobName2, inpFile2, numCPU);
%disp(['Submetendo job2: ', cmd]);
%status2 = system(cmd);

% Control variables
SubmitWork = true;           % control the running and stopping of the Job1
SubmitWork2 = false;         % control the running and stopping of the Job2

inter_job1 = 0;
inter_job2 = 0;
indice_p = 1E10;    % records the maximum value of the reading load and is initially set to infinity
inter = 0;    

                                            
PauseTime = 3;   % time betwen verifications

disp('Monitorando execução do Abaqus...');

while SubmitWork || SubmitWork2
    inter = inter + 1;          
    if inter==1                     
        pause(PauseTime);   % Waiting for abaqus response required after the first job submission by Matlab
    end

% The *.lck file is the file that is generated after starting the calculation and is
% automatically deleted at the end of the calculation. Thus, this can be used as one of
% the criteria for determining the end of the monitoring loop.

    % Check .lck — to indicate that the job1 is working
    if exist([JobName1, '.lck'], 'file') ~= 2 && SubmitWork
        disp(['Job ', JobName1, ' finalizado by terminate']);
        cmd2 = sprintf('abaqus job= %s terminate', JobName1);
        SubmitWork = 0;
    end

    % When Job1 generates the .dat file, monitoring initiates and continues
    %                                        until the analysis is complete

    if exist([JobName1, '.dat'], 'file') == 2
        try
            if SubmitWork==1              
                [nodeforce, peaknow, lessnow] = monitorDATfile(JobName1);
                % Att max value observed
                if isempty(peaknow)==0
                    indice_p = peaknow;
                end

                % If atual value exceds the peak, terminate job1
                if nodeforce(end) > indice_p
                    disp('Job1 terminado com sucesso by full analysis!');
                    cmd3 = sprintf('abaqus job= %s terminate', JobName1);
                end
            end

            % When Force < 0 → inicialize Job2
            if min(nodeforce)<0 && inter_job2==0
                disp(['Critério atingido → iniciando Job2.../n', cmd]);
                cmd4 = sprintf('abaqus job=%s input="%s" cpus=%d', JobName2, inpFile2, numCPU);
                status2 = system(cmd4);
                if status2 == 0
                    disp('Job2 submetido com sucesso!');
                else
                    disp('Erro ao submeter o job2.');
                end
                SubmitWork2 = true;
                inter_job2 = inter_job2 + 1;
                pause(PauseTime);
            end

            % Monitor Job2 in progress
            if min(nodeforce)<0 && inter_job2 ==1 && SubmitWork2==1

  disp(' ############## SO FAR SO GOOD?!...  #########################');

                [nodeforce2, peaknow2, lessnow2] = monitorDATfile(JobName2);

                % Once Job2 loaded to the local minmum of Job1, terminate
                if min(nodeforce2) < min(nodeforce)
                    disp('Job2 terminado com sucesso by terminate!');
                    cmd5 = sprintf('abaqus job= %s terminate', JobName2);
                    SubmitWork2 = false
                end

                % Check .lck — to indicate that the job1 is working
                if exist([JobName2, '.lck'], 'file') ~= 2
                    cmd6 = sprintf('abaqus job= %s terminate', JobName2); 
                    disp('Job2 terminado com sucesso by full analysis!');
                    SubmitWork2 = 0;
                end
            end
        catch ME
            disp(['Erro no monitoramento: ', ME.message]);
        end
    end

    % Sai do loop se ambos encerraram
    if SubmitWork && SubmitWork2
        break;
    end
end

disp('Monitoramento concluído com sucesso!');

