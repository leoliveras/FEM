function readHistoryOdbPyScript(odbfile, filename, FolderName_Input, outfile)
% Gera um script Python (.py) IDENTICO ao script Abaqus validado

FullPath_Py = fullfile(FolderName_Input, ['readHistoryOdb_', filename, '.py']);
fid = fopen(FullPath_Py, 'w');

fprintf(fid, 'from abaqus import *\n');
fprintf(fid, 'from abaqusConstants import *\n');
fprintf(fid, 'import displayGroupMdbToolset as dgm\n');
fprintf(fid, 'import regionToolset\n');
fprintf(fid, 'import xyPlot\n');
fprintf(fid, '#import displayGroupOdbToolset as dgo\n');
fprintf(fid, 'import connectorBehavior\n');
fprintf(fid, 'import os\n');
fprintf(fid, 'import visualization\n\n');

fprintf(fid, '# Caminhos (use r''...'' para evitar erro de barra invertida)\n');
fprintf(fid, 'odb_path = r''%s''\n', odbfile);
fprintf(fid, 'out_name = r''%s_loaddisp.txt''\n\n', outfile);

fprintf(fid, '# Abre o ODB (caso não esteja aberto)\n');
fprintf(fid, 'if odb_path not in session.odbs.keys():\n');
fprintf(fid, '    odb = session.openOdb(name=odb_path)\n');
fprintf(fid, 'else:\n');
fprintf(fid, '    odb = session.odbs[odb_path]\n\n');

fprintf(fid, '# --- Nomes das variáveis do History Output ---\n');
fprintf(fid, 'cf_path = "Point loads: CF2 at Node 2 in NSET RP-TOP"\n');
fprintf(fid, 'u2_path = "Spatial displacement: U2 at Node 2 in NSET RP-TOP"\n\n');

fprintf(fid, '# --- Extrai dados do ODB ---\n');
fprintf(fid, 'xy_cf = session.XYDataFromHistory(\n');
fprintf(fid, '    name="CF2",\n');
fprintf(fid, '    odb=odb,\n');
fprintf(fid, '    outputVariableName=cf_path,\n');
fprintf(fid, '    steps=("Step-1",),\n');
fprintf(fid, '    suppressQuery=True\n');
fprintf(fid, ')\n\n');

fprintf(fid, 'xy_u2 = session.XYDataFromHistory(\n');
fprintf(fid, '    name="U2",\n');
fprintf(fid, '    odb=odb,\n');
fprintf(fid, '    outputVariableName=u2_path,\n');
fprintf(fid, '    steps=("Step-1",),\n');
fprintf(fid, '    suppressQuery=True\n');
fprintf(fid, ')\n\n');

fprintf(fid, '##################### OLD  ################################################\n');
fprintf(fid, '# --- Combina deslocamento x carga --- \n');
fprintf(fid, '#xy_combined = combine(-xy_u2, -xy_cf) \n');
fprintf(fid, '#y_combined.setValues(sourceDescription="Load vs Displacement")\n');
fprintf(fid, '###########################################################################\n\n');

fprintf(fid, '# --- Combina deslocamento x carga (versão corrigida) ---\n');
fprintf(fid, '# Converte para listas e cria pares (U2, CF2)\n');
fprintf(fid, 'list_u2 = list(xy_u2)\n');
fprintf(fid, 'list_cf = list(xy_cf)\n');
fprintf(fid, 'data = [(-u_pt[1], -cf_pt[1]) for u_pt, cf_pt in zip(list_u2, list_cf)]\n\n');

fprintf(fid, '###########################################################################\n');
fprintf(fid, '# ----- Garantir nome "Y" sem prefixo/sufixo -----\n');
fprintf(fid, 'desired_name = "Y"\n\n');

fprintf(fid, '# 1) Remove entradas antigas que conflitem (por segurança)\n');
fprintf(fid, 'keys_to_remove = []\n');
fprintf(fid, 'for key in list(session.xyDataObjects.keys()):\n');
fprintf(fid, '    # Normaliza: remove leading underscores e sufijos tipo _1, _2\n');
fprintf(fid, '    norm = key.lstrip(''_'' )\n');
fprintf(fid, '    # remove trailing _number se existir\n');
fprintf(fid, '    import re\n');
fprintf(fid, '    norm = re.sub(r''_[0-9]+$'', '''', norm)\n');
fprintf(fid, '    if norm == desired_name:\n');
fprintf(fid, '        keys_to_remove.append(key)\n\n');

fprintf(fid, 'for k in keys_to_remove:\n');
fprintf(fid, '    try:\n');
fprintf(fid, '        del session.xyDataObjects[k]\n');
fprintf(fid, '    except Exception:\n');
fprintf(fid, '        # se não puder deletar, apenas ignore\n');
fprintf(fid, '        pass\n\n');

fprintf(fid, '# 2) Cria XYData com nome temporário (evita conflitos)\n');
fprintf(fid, 'temp_name = "__temp_Y__"\n');
fprintf(fid, 'if temp_name in session.xyDataObjects.keys():\n');
fprintf(fid, '    try:\n');
fprintf(fid, '        del session.xyDataObjects[temp_name]\n');
fprintf(fid, '    except Exception:\n');
fprintf(fid, '        pass\n\n');

fprintf(fid, '###########################################################################\n\n');

fprintf(fid, 'xy_temp = xyPlot.XYData(\n');
fprintf(fid, '    name=temp_name,\n');
fprintf(fid, '    data=data,\n');
fprintf(fid, '    xValuesLabel="Deslocamento Y",\n');
fprintf(fid, '    yValuesLabel="Carga Y"\n');
fprintf(fid, ')\n\n');

fprintf(fid, '###########################################################################\n\n');

fprintf(fid, '# 3) Renomeia explicitamente para o nome desejado ("Y")\n');
fprintf(fid, '# Se já existir uma chave "Y" (improvável, pois removemos), substituímos\n');
fprintf(fid, 'if desired_name in session.xyDataObjects.keys():\n');
fprintf(fid, '    try:\n');
fprintf(fid, '        del session.xyDataObjects[desired_name]\n');
fprintf(fid, '    except Exception:\n');
fprintf(fid, '        pass\n\n');

fprintf(fid, '# efetua a mudança de chave\n');
fprintf(fid, 'session.xyDataObjects.changeKey(temp_name, desired_name)\n\n');

fprintf(fid, '# agora recupere o objeto final se quiser usar depois\n');
fprintf(fid, 'xy_combined = session.xyDataObjects[desired_name]\n\n');

fprintf(fid, '# --- Salva dados em arquivo texto ---\n');
fprintf(fid, 'session.writeXYReport(\n');
fprintf(fid, '    fileName=out_name,\n');
fprintf(fid, '    appendMode=OFF,\n');
fprintf(fid, '    xyData=(xy_combined,)\n');
fprintf(fid, ')\n\n');

fprintf(fid, 'print("✅ Arquivo salvo com sucesso em:", out_name)\n');

fclose(fid);
end
