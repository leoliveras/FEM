function [nodeforce,peaknow,lessnow]=monitorDATfile(JobName)

    fid = textread([JobName, '.dat'],'%s' ,'delimiter', '\n');
    % Find location by string 'NODE FOOT- RF2 ' 
    pos=find(strcmp(fid,'NODE FOOT-  RF2          '));

    % Find location by string ' RF2 '
    %pos=find(strcmp(fid, 'RF2'));   
    %pos = find(contains(fid, 'RF2')); % more ample 

    % if nothing was detected return empty
    if isempty(pos)
        disp(['[monitorDATfile] Nenhum dado encontrado em ', JobName, '.dat']);
        return;
    end

    % Fetch the sequence of positions corresponding to all  stored values of rection force in U2 direction
    pos_arr=fid(pos+3);

    % Filtra apenas linhas que parecem conter números
    %os_arr = pos_arr(~cellfun(@isempty, regexp(pos_arr, '\d')));

    % Separate out the strings corresponding to the stored  data of RF2
    pos_value_arr=split(pos_arr)

    % Array initialization
    %nodeforce = zeros(length(pos_arr), 1);

   
    for k=1: size(pos_value_arr,1) 
        nodeforce(k)=-str2double(pos_value_arr{k,2});
    end


    % Remove NaNs (if the conversion fails)
    %nodeforce = nodeforce(~isnan(nodeforce));

    % Return the local maximum and minimum values of this  array
    [peaknow,peaknow_ind]=findpeaks(nodeforce);
    [lessnow,less_ind]=findpeaks(-nodeforce); 
end
