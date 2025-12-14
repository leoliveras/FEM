function UNIM = main()
% MASTER_UNVISC - programa principal para solução 1D de problemas não-lineares

%% --- Inicialização 
UNIM = data();
UNIM = inital(UNIM);
UNIM = stunvp(UNIM); 

UNIM.TTIME = 0.0;

%% --- Loop de incrementos de carga
for IINCS = 1:UNIM.NINCS
    UNIM.IINCS = IINCS;

    UNIM = inclod(UNIM);
    UNIM.DTIME = 0.0;

    converged = false;

    %% --- Loop interno de passos
    for ISTEP = 1:UNIM.NSTEP
        UNIM.ISTEP = ISTEP;
        UNIM.TTIME = UNIM.TTIME + UNIM.DTIME;

        UNIM = nonal(UNIM);
        UNIM = assembl(UNIM);

        if UNIM.KRESL == 1
            UNIM = greduc(UNIM);
        elseif UNIM.KRESL == 2
            UNIM = resolv(UNIM);
        end

        UNIM = baksub(UNIM);
        UNIM = incvp(UNIM);
        UNIM = convp(UNIM);

        % --- Teste de convergência 
        if UNIM.NCHEK == 0
            converged = true;
            UNIM = result(UNIM);  
            break
        end

        % --- Saídas intermediárias
        if ISTEP == 1 && UNIM.NOUTP == 1
            UNIM = result(UNIM);
        elseif UNIM.NOUTP == 2
            UNIM = result(UNIM);
        end
    end

    % --- IF NCHECK=999 STEADY STATE NOT ACHIEVED
    if ~converged
        error('STEADY STATE NOT ACHIEVED');
    end
end
end



    % 1) Define manualmente os dados do problema
    function UNIM = data()

%       Le os dados do problema (input);
%       Define NEVAB p/ fazer o loop e ler o vetor de cargas externas
%       Define NSVAB p/ fazer o loop e armazenar o deslocamento prescrito
%       Cria IFPRE p/ identificar grau de liberdade que tem valor prescrito
%       Cria PREFIX para armazenar o valor do deslocamento prescrito

% Em vez de ler ficheiro, colocou-se os inputs diretamente aqui.

%% --- Título do problema
UNIM.TITLE = 'Exemplo Unidimensional Cap4.1';

%% --- Parâmetros de controlo
UNIM.NPOIN = 2;     % nº de nós                                     (INPUT)
UNIM.NELEM = 1;     % nº de elementos                               (INPUT)
UNIM.NBOUN = 1;     % nº de condições de contorno                   (INPUT)
UNIM.NMATS = 1;     % nº de materiais                               (INPUT)   
UNIM.NPROP = 5;     % nº de propriedades por material               (INPUT)
UNIM.NNODE = 2;     % nós por elemento                              (INPUT)
UNIM.NINCS = 1;     % nº de incrementos de carga                    (INPUT)
UNIM.NALGO = 3;     % algoritmo (1 = padrão)                        (INPUT)
UNIM.NDOFN = 1;     % graus de liberdade por nó                     (INPUT)

fprintf(['    NPOIN = %d     NELEM = %d     NBOUN = %d     NMATS = %d' ...
         '    NPROP = %d     NNODE = %d     NINCS = %d     NALGO = %d' ...
         '    NDOFN = %d \n'], UNIM.NPOIN, UNIM.NELEM, UNIM.NBOUN, ...
                               UNIM.NMATS, UNIM.NPROP, UNIM.NNODE, ...
                               UNIM.NINCS, UNIM.NALGO, UNIM.NDOFN);

% Derivados
UNIM.NEVAB = UNIM.NDOFN * UNIM.NNODE;
UNIM.NSVAB = UNIM.NDOFN * UNIM.NPOIN;

%% --- Propriedades do(s) material(is)
% PROPS(jmats, iprop)
UNIM.PROPS = zeros(UNIM.NMATS, UNIM.NPROP);
UNIM.PROPS(1,:) = [10000,  ... % [E]                                (INPUT)
                   1.0,    ... % [ν]                                (INPUT)
                   10.0,   ... % [σy]                               (INPUT)
                   5000.0, ... % [H']                               (INPUT)
                   0.001];     % [gamma]                            (INPUT)
fprintf ('    MATERIAL PROPERTIES \n')
for i=1:UNIM.NMATS
fprintf ('    %d    %d    %d    %d    %d\n', UNIM.PROPS(i,1), ...
                                             UNIM.PROPS(i,2),...
    UNIM.PROPS(i,3),UNIM.PROPS(i,4),UNIM.PROPS(i,5))
end
%% --- Conectividade (LNODS) e materiais (MATNO)
% Elemento 1: nós 1-2, material 1
% Elemento 2: nós 2-3, material 1
UNIM.LNODS = [1 2];  % Conectividade do Elemento 1                  (INPUT)
UNIM.MATNO = [1];    % Tipo do material do Elemento 1               (INPUT)
fprintf('    ELEM    NODES    MATERIAL\n')
for i=1:UNIM.NELEM
    fprintf('    %d     %d     %d     %d\n', i, ...
                                             UNIM.LNODS(i), ...
                                             UNIM.LNODS(i+1), ...
                                             UNIM.MATNO(i))
end

%% --- Coordenadas dos nós
UNIM.COORD = [0.0, ...   % Coordenada do no 1 do Elemento 1         (INPUT) 
              10.0];     % Coordenada do no 2 do Elemento 1         (INPUT) 
fprintf('   NODE   COORD\n')
for i=1:UNIM.NNODE
    fprintf('    %d     %d\n', i, UNIM.COORD(i))
end

%% --- Condições de contorno (exemplo: nó 1 fixo)
UNIM.IFPRE(UNIM.NSVAB)=0;
UNIM.PEFIX(UNIM.NSVAB)=0;

fprintf('   RES. NODE     CODE     PRES. VALUES\n')

% nó 1, GL 1, deslocamento prescrito = 0
ICODE = [1 0];  % Identifica se o no tem deslocamento               (INPUT)
VALUE = [0 0];  % Valor do deslocamento para o no                   (INPUT)
NDOFX = 1;      % Numero de deslocamentos prescritos em x           (INPUT)
NPOSN = (NDOFX-1) * UNIM.NDOFN;

for IDOFN=1, UNIM.NDOFN;
    NPOSN = NPOSN+1;
    UNIM.IFPRE(NPOSN) = ICODE(IDOFN);
    UNIM.PEFIX(NPOSN) = VALUE (IDOFN);

    fprintf('    %d              %d          %d\n', IDOFN, ...
                                                    UNIM.IFPRE(IDOFN), ...
                                                    UNIM.PEFIX(IDOFN))
end

%% --- Cargas nodais equivalentes (RLOAD)
UNIM.RLOAD = zeros(UNIM.NELEM, UNIM.NEVAB);

UNIM.RLOAD(1,2) = 15.0;   % Exemplo: aplicar carga 15 no nó 2       (INPUT)
fprintf('   ELEMENT          NODAL LOADS\n')
for i=1:UNIM.NELEM
    fprintf('    %d              %d             %d\n', i, ...
                                                       UNIM.RLOAD(i,1), ...
                                                       UNIM.RLOAD(i,2))
end
%% --- Parâmetros de tempo
UNIM.TAUFT = 0.05;  % Define o                                      (INPUT)
UNIM.DTINT = 0.025; % Define o                                      (INPUT)
UNIM.FTIME = 1.5;   % Define                                        (INPUT)
fprintf('TAUFT = %d     DTINT = %d     FTIME = %d\n',UNIM.TAUFT, ...
                                                     UNIM.DTINT, ...
                                                     UNIM.FTIME)

end

    % 2) Inicializa arrays acumulativos com zero
    function UNIM = inital(UNIM)

% Inputs:
%   UNIM - struct com dados do problema (criado em data.m)
% Outputs:
%   UNIM - struct com campos atualizados para zero

%% Plastic strains
UNIM.PLAST(UNIM.NELEM) = 0;

%% Stresses
UNIM.STRES = zeros(UNIM.NELEM, UNIM.NDOFN);

%% Element loads (ELOAD, TLOAD)
UNIM.ELOAD = zeros(UNIM.NELEM, UNIM.NEVAB);  % pseudo carga
UNIM.TLOAD = zeros(UNIM.NELEM, UNIM.NEVAB);  % carga total

%% Nodal displacements (TDISP) e reactions (TREAC)
UNIM.TDISP = zeros(UNIM.NPOIN, UNIM.NDOFN);  %valores dos deslocamentos
UNIM.TREAC = zeros(UNIM.NPOIN, UNIM.NDOFN);  %valores das reacoes

% (Outros arrays como XDISP, FRESV, ASTIF etc.
%  podem ser inicializados aqui se necessário, 
%  mas no Fortran original só estes eram zerados nesta subrotina.)

end

    % 3) Main cria as matrizes de rigidez por meio do STVNP
    function UNIM = stunvp(UNIM)
% STVNP - calcula matrizes de rigidez dos elementos 1D
%
% Entrada:
%   UNIM - struct com dados do problema (NPOIN, NELEM, LNODS, PROPS, MATNO, COORD)
% Saída:
%   UNIM - struct atualizado com ESTIF armazenado em UNIM.ESTIFelem

% Prealoca array para todas as matrizes de rigidez elementares
% ESTIFelem(:,:,ie) será a matriz do elemento ie
UNIM.ESTIFelem = zeros(UNIM.NNODE, UNIM.NNODE, UNIM.NELEM);

for IELEM = 1:UNIM.NELEM
    % --- Propriedades do elemento
    LPROP = UNIM.MATNO(IELEM);      % qual material
    YOUNG = UNIM.PROPS(LPROP,1); % módulo de Young
    XAREA = UNIM.PROPS(LPROP,2); % área da seção
    NODE1 = UNIM.LNODS(IELEM,1);    % nó 1
    NODE2 = UNIM.LNODS(IELEM,2);    % nó 2
    
    % Comprimento do elemento
    ELENG = abs(UNIM.COORD(NODE1) - UNIM.COORD(NODE2));
    
    % Multiplicador
    FMULT = YOUNG * XAREA / ELENG;
    
    % --- Matriz de rigidez do elemento 1D
    ESTIF = [ FMULT  -FMULT;
             -FMULT   FMULT ];
    
    % Armazena
    UNIM.ESTIFelem(:,:,IELEM) = ESTIF;
    
    % --- Opcional: imprimir para depuração
    %fprintf('Elemento %d, ESTIF =\n', ie);
    %disp(estif)

    %fields = fieldnames(UNIM);


    end
end

        % 4) Comeca o loop de iteracoes (NSTEP)
        function UNIM = inclod(UNIM)
    % INCLOD - atualiza vetor de cargas para o incremento atual
    %
    % Entrada: UNIM - struct com dados e cargas
    % Saída: UNIM - struct atualizada
    
    % --- Parâmetros do incremento (valores de exemplo)
    % Em Fortran, eram lidos de arquivo:
    UNIM.NSTEP = 90;   % número de steps no incremento
    UNIM.NOUTP = 2;   % saída de resultados
    UNIM.FACTO = 1.0; % fator multiplicativo do incremento
    UNIM.TOLER = 0.1;
    
    fprintf('Incremento %d: NSTEP=%d, NOUTP=%d, FACTO=%.6f, TOLER=%.6e\n', ...
        UNIM.IINCS, UNIM.NSTEP, UNIM.NOUTP, UNIM.FACTO, UNIM.TOLER);
    
    % --- Atualiza vetores de carga
    for IELEM = 1:UNIM.NELEM
        for IEVAB = 1:UNIM.NEVAB
            UNIM.ELOAD(IELEM,IEVAB) = UNIM.ELOAD(IELEM,IEVAB) + UNIM.RLOAD(IELEM,IEVAB) * UNIM.FACTO;
            UNIM.TLOAD(IELEM,IEVAB) = UNIM.TLOAD(IELEM,IEVAB) + UNIM.RLOAD(IELEM,IEVAB) * UNIM.FACTO;
        end
    end
    
    end
    
        % 5) Comeca o loop de incrementos de carga (NSTEP)
        function UNIM = nonal(UNIM)
    % NONAL - define tipo de solução e atualiza vetor de valores prescritos
    %
    % Entrada: UNIM - struct com dados do problema
    % Saída: UNIM - struct atualizada
    
    % --- Inicializa o indicador de resolução
    UNIM.KRESL = 2;
    
    % --- Define KRESL dependendo do algoritmo e do incremento/step
    if UNIM.NALGO == 1
        UNIM.KRESL = 1;
    elseif UNIM.NALGO == 2
        UNIM.KRESL = 1;
    elseif UNIM.NALGO == 3 && UNIM.IINCS == 1 && UNIM.ISTEP == 1
        UNIM.KRESL = 1;
    elseif UNIM.NALGO == 4 && UNIM.ISTEP == 1
        UNIM.KRESL = 1;
    elseif UNIM.NALGO == 5 && UNIM.IINCS == 1 && UNIM.ISTEP == 1
        UNIM.KRESL = 1;
    elseif UNIM.NALGO == 6 && UNIM.ISTEP == 2
        UNIM.KRESL = 1;
    end
    
    
    
    % --- Atualiza vetor FIXED
    if UNIM.ISTEP == 1 || UNIM.NALGO == 1
        % Pega os valores de PEFIX multiplicados pelo FACTO
        for ISVAB = 1:UNIM.NSVAB
            UNIM.FIXED(ISVAB) = UNIM.PEFIX(ISVAB) * UNIM.FACTO;
        end
    else
            % Se não for o step inicial, zera FIXED
        for ISVAB = 1:UNIM.NSVAB
            UNIM.FIXED(ISVAB) = 0.0;
        end
    
    end
    
    end
    
        % 6) Monta matriz global iteracao i (NSTEP(i))
        function UNIM = assembl(UNIM)
    % ASSEMB - montagem global do vetor de cargas e matriz de rigidez
    
    UNIM.ASLOD(1:UNIM.NSVAB)=0.0;
    
    if UNIM.KRESL ~= 2
        UNIM.ASTIF = zeros(UNIM.NSVAB, UNIM.NSVAB); 
    end
    
    for ielem = 1:UNIM.NELEM
        % --- pega a matriz de rigidez do elemento
        estif = UNIM.ESTIFelem(:,:,ielem);
        
        for inode = 1:UNIM.NNODE
            nodei = UNIM.LNODS(ielem, inode);
            for idofn = 1:UNIM.NDOFN
                nrows = (nodei - 1) * UNIM.NDOFN + idofn;
                nrowe = (inode - 1) * UNIM.NDOFN + idofn;  % índice LOCAL no elemento
                
                % --- vetor global de cargas
                UNIM.ASLOD(nrows) = UNIM.ASLOD(nrows) + UNIM.ELOAD(ielem, nrowe);
                
                if UNIM.KRESL ~= 2
                    % para o jnode=1 e NLODS(1,2)
                    for jnode = 1:UNIM.NNODE
                        %nodej = NLODS(1,2) = 2
                        nodej = UNIM.LNODS(ielem, jnode);
                        % para jdofn=1 e NDOFN=1
                        for jdofn = 1:UNIM.NDOFN
                            ncols = (nodej - 1) * UNIM.NDOFN + jdofn;  % índice global
                            ncole = (jnode - 1) * UNIM.NDOFN + jdofn;   % índice LOCAL no estif
                            
                            % --- acumula rigidez
                            %% 
                            UNIM.ASTIF(nrows, ncols) = UNIM.ASTIF(nrows, ncols) + estif(nrowe, ncole);             
                        end
                    end
                end
            end
        end
    end
    end
    
        % 7) Reducao das eq's do sistema
        function UNIM = greduc(UNIM)
    % GREDUC - Gaussian reduction routine (eliminação por redução)
    % Entrada:  UNIM - struct com campos necessários (ASTIF, ASLOD, IFPRE, FIXED, FRESV, NSVAB, ...)
    % Saída:    UNIM - struct atualizado (ASTIF, ASLOD modificados; FRESV preenchido)
    %
    % Observações:
    % - Tolerância de pivot igual ao original (1e-10).
    % - Em caso de pivô muito pequeno a função dispara erro, similar ao STOP do Fortran.
    
    
    UNIM.KOUNT = 0;
    NEQNS=UNIM.NSVAB;
    tolPivot = 1.0e-10;
    
    % Loop sobre equações
    for IEQNS = 1:NEQNS
        % Se o dof estiver prescrito, ajustar RHS e pular redução
        if UNIM.IFPRE(IEQNS) == 1
            % ADJUST RHS (LOADS) FOR PRESCRIBED DISPLACEMENTS (Fortran label 40)
            for IROWS = IEQNS:NEQNS
                UNIM.ASLOD(IROWS) = UNIM.ASLOD(IROWS) - UNIM.ASTIF(IROWS, IEQNS) * UNIM.FIXED(IEQNS);
            end
            continue
        end
    
        % REDUCE EQUATIONS
        pivot = UNIM.ASTIF(IEQNS, IEQNS);
        if abs(pivot) < tolPivot
            error('GREDUC: pivô incorreto (próximo de zero) na linha %d (valor = %g).', IEQNS, pivot);
        end
    
        if IEQNS == NEQNS
            % última equação, nada a reduzir
            continue
        end
    
      
        for IROWS = IEQNS + 1 : NEQNS;
            UNIM.KOUNT = UNIM.KOUNT + 1;
            FACTR = UNIM.ASTIF(IROWS, IEQNS) / pivot;
            FRESV(KOUNT) = FACTR
            
            %
            if FACTR ~= 0
                % Subtrai múltiplo da linha-pivô das colunas IEQNS..NEQNS
                % vetorizar operação para velocidade quando possível
                UNIM.ASTIF(IROWS, IEQNS:NEQNS) = UNIM.ASTIF(IROWS, IEQNS:NEQNS) - FACTR * UNIM.ASTIF(IEQNS, IEQNS:NEQNS);
            end
    
            % Ajusta RHS
            UNIM.ASLOD(IROWS) = UNIM.ASLOD(IROWS) - FACTR * UNIM.ASLOD(IEQNS);
        end
    end
    
    % Opcional: armazenar KOUNT caso queira usar depois
    %UNIM.GREDUC_KOUNT = KOUNT;
    %UNIM.FRESV(KOUNT) = FACTR;
    
        
        end
    
        % 8) Retro-substituição nas eq's para solucao do sistema
        function UNIM = baksub(UNIM)
    % BAKSUB - back-substitution routine (conversão da subrotina Fortran BAKSUB)
    %
    % Entrada/saída:
    %   UNIM - struct com campos necessários:
    %          ASTIF, ASLOD, IFPRE, FIXED, XDISP, REACT, TDISP, TREAC, TLOAD, LNODS, ...
    %
    % Observações:
    % - Se campos como XDISP ou REACT não existirem, inicializo com zeros.
    
    
    % Zera REACT (como no Fortran)
    NEQNS=UNIM.NSVAB;
    UNIM.REACT(1:NEQNS) = 0.0;
    
    % Back-substitution: percorrer das equações de baixo para cima
    NEQN1 = NEQNS + 1;
    if UNIM.ISTEP==1
        UNIM.XDISP(NEQNS) = 0.0;
    end
    
    for IEQNS = 1:NEQNS
        NBACK = NEQN1 - IEQNS;                % conta: NEQNS, NEQNS-1, ..., 1
        PIVOT = UNIM.ASTIF(NBACK, NBACK);
        RESID = UNIM.ASLOD(NBACK);
        % subtrai contribuições das colunas já determinadas (se houver)
        if NBACK ~= NEQNS
           NBAC1 = NBACK + 1;
           % resid = resid - sum_{ICOLS=NBAC1..NEQNS} ASTIF(NBACK,ICOLS)*XDISP(ICOLS)
           RESID = RESID - UNIM.ASTIF(NBACK, NBAC1:NEQNS) * UNIM.XDISP(NBAC1:NEQNS);
        end
    
        % se grau livre -> solução por divisão pelo pivô
        if UNIM.IFPRE(NBACK) == 0
           UNIM.XDISP(NBACK) = RESID / PIVOT;
        else
        % se prescrito, deslocamento é FIXED e reação é -resid
           UNIM.XDISP(NBACK) = UNIM.FIXED(NBACK);
           UNIM.REACT(NBACK) = -RESID;
        end
    end
    
    % Agora propagar XDISP e REACT para TDISP e TREAC (nó/GL mapping)
    % KOUNT usado apenas para indexação nos DO's originais
    if UNIM.ISTEP == 1
    UNIM.TDISP = zeros(UNIM.NPOIN, UNIM.NDOFN);
    UNIM.TREAC = zeros(UNIM.NPOIN, UNIM.NDOFN);
    end
    
    UNIM.KOUNT = 0;
    
    for IPOIN = 1:UNIM.NPOIN
        for IDOFN = 1:UNIM.NDOFN
            UNIM.KOUNT = UNIM.KOUNT + 1;
            % soma incremental: TDISP(node, dof) += XDISP(kcount)
            
            UNIM.TDISP(IPOIN, IDOFN) = UNIM.TDISP(IPOIN, IDOFN) + UNIM.XDISP(UNIM.KOUNT);
            UNIM.TREAC(IPOIN, IDOFN) = UNIM.TREAC(IPOIN, IDOFN) + UNIM.REACT(UNIM.KOUNT);
        end
    end
    
    % Finalmente: adicionar reações a TLOAD dos elementos.
    % O Fortran faz:
    % for IPOIN=1..NPOIN
    %   for IELEM=1..NELEM
    %     for INODE=1..NNODE
    %       if IPOIN == LNODS(IELEM,INODE) then
    %         for IDOFN=1..NDOFN
    %           NPOSN=(IPOIN-1)*NDOFN+IDOFN
    %           IEVAB=(INODE-1)*NDOFN+IDOFN
    %           TLOAD(IELEM,IEVAB)=TLOAD(IELEM,IEVAB)+REACT(NPOSN)
    %         end
    %       end
    %     end
    %   end
    % end
    
    
    for IPOIN = 1:UNIM.NPOIN
     for IELEM = 1:UNIM.NELEM
      for INODE = 1:UNIM.NNODE
          NLOCA = UNIM.LNODS(IELEM, INODE);
       if IPOIN == NLOCA
        for IDOFN = 1:UNIM.NDOFN
            NPOSN = (IPOIN - 1) * UNIM.NDOFN + IDOFN;
            IEVAB = (INODE - 1) * UNIM.NDOFN + IDOFN;
               
       UNIM.TLOAD(IELEM, IEVAB) = UNIM.TLOAD(IELEM, IEVAB) + UNIM.REACT(NPOSN);   
        end
       end
      end
     end
    end
    
    end
    
        % 9) Resolucao do sistema
        function UNIM = resolv(UNIM)
    % RESOLV - resolving Gaussian reduction routine
    %
    % Entrada/Saída:
    %   UNIM - struct com:
    %          NSVAB, ASTIF, ASLOD, FIXED, IFPRE, FRESV
    %
    % Implementa a subrotina RESOLV do Fortran.
    
    kount = 0;
    neqns = UNIM.NSVAB;
    
    for ieqns = 1:neqns
        if UNIM.IFPRE(ieqns) ~= 1
            % redução do lado direito (RHS)
            if ieqns ~= neqns
                ieqn1 = ieqns + 1;
                for irows = ieqn1:neqns
                    kount = kount + 1;
                    factr = UNIM.FRESV(kount);
                    if factr ~= 0
                        UNIM.ASLOD(irows) = UNIM.ASLOD(irows) - factr * UNIM.ASLOD(ieqns);
                    end
                end
            end
        else
            % ajuste para deslocamento prescrito
            for irows = ieqns:neqns
                UNIM.ASLOD(irows) = UNIM.ASLOD(irows) - UNIM.ASTIF(irows,ieqns) * UNIM.FIXED(ieqns);
            end
        end
    end
    
    end
    
        % 10) Calcular forcas nodais equivalentes internas
        function UNIM = incvp(UNIM)
        % INCVP - calcula forças nodais equivalentes internas (conversão direta de FORTRAN)
        % Entrada/Saída:
        %   UNIM - struct com campos necessários (NELEM, NNODE, NEVAB, PROPS, LNODS, COORD,
        %          XDISP, TDISP, STRES, PLAST, VIVEL, TLOAD, ELOAD, TAUFT, DTINT, FTIME,
        %          DTIME, ISTEP, etc.)
        %
        % Observação: função assume que todos os campos necessários já existem em UNIM.
    
    % --- Zera ELOAD
    for ielem = 1:UNIM.NELEM
        for ievab = 1:UNIM.NEVAB
            UNIM.ELOAD(ielem, ievab) = 0.0;
        end
    end
    
    % --- determina DNEXT inicial (estabelece limite de tempo)
    DNEXT = UNIM.FTIME * UNIM.DTIME;
    
    % --- Loop principal sobre elementos para atualizar tensões/plasticidade/velocidades
    for ielem = 1:UNIM.NELEM
        lprop = UNIM.MATNO(ielem);
        young = UNIM.PROPS(lprop,1);
        xarea = UNIM.PROPS(lprop,2);
        yield = UNIM.PROPS(lprop,3);
        hards = UNIM.PROPS(lprop,4);
        gamma = UNIM.PROPS(lprop,5);
        
        node1 = UNIM.LNODS(ielem,1);
        node2 = UNIM.LNODS(ielem,2);
        eleng = abs(UNIM.COORD(node1) - UNIM.COORD(node2));
        
        % compute engineering strain increment (sign depends on node ordering)
        if UNIM.COORD(node2) > UNIM.COORD(node1)
            stran = (UNIM.XDISP(node2) - UNIM.XDISP(node1)) / eleng;
        else
            stran = (UNIM.XDISP(node1) - UNIM.XDISP(node2)) / eleng;
        end
        
        if UNIM.ISTEP==1
        UNIM.VIVEL(UNIM.NELEM) = 0.0;
        end 
        
        % update stress and plastic strain
        UNIM.STRES(ielem,1) = UNIM.STRES(ielem,1) + (stran - UNIM.VIVEL(ielem) * UNIM.DTIME) * young;
        UNIM.PLAST(ielem) = UNIM.PLAST(ielem) + UNIM.VIVEL(ielem) * UNIM.DTIME;
        
        % adjust yield sign if stress negative
        if UNIM.STRES(ielem,1) < 0.0
            yield_loc = -yield;
        else
            yield_loc = yield;
        end
        preys = yield_loc + hards * UNIM.PLAST(ielem);
        
        % check yielding condition
        if abs(UNIM.STRES(ielem,1)) <= abs(preys)
            % elastic (no viscous slip)
            UNIM.VIVEL(ielem) = 0.0;
        else
            % viscous sliding occurs
            UNIM.VIVEL(ielem) = gamma * (UNIM.STRES(ielem,1) - (yield_loc + hards * UNIM.PLAST(ielem)));
            % compute SNTOT and candidate DELTM
            sntot = (UNIM.TDISP(node2,1) - UNIM.TDISP(node1,1)) / eleng;
            deltm = UNIM.TAUFT * abs(sntot / UNIM.VIVEL(ielem));
            if deltm < DNEXT
                DNEXT = deltm;
            end
        end
    end
    
    % --- update DTIME
    UNIM.DTIME = DNEXT;
    if UNIM.ISTEP == 1
        UNIM.DTIME = UNIM.DTINT;
    end
    
    % --- Cálculo das forças internas por elemento (ELOAD)
    for ielem = 1:UNIM.NELEM
        lprop = UNIM.MATNO(ielem);
        young = UNIM.PROPS(lprop,1);
        xarea = UNIM.PROPS(lprop,2);
        
        node1 = UNIM.LNODS(ielem,1);
        node2 = UNIM.LNODS(ielem,2);
     
        
        % FACTR = (YOUNG * VIVEL * DTIME - STRES) * XAREA
        factr = (young * UNIM.VIVEL(ielem) * UNIM.DTIME - UNIM.STRES(ielem,1)) * xarea;
        
        if UNIM.COORD(node2) > UNIM.COORD(node1)
            UNIM.ELOAD(ielem,1) = -factr;
            UNIM.ELOAD(ielem,2) =  factr;
        else
            UNIM.ELOAD(ielem,1) =  factr;
            UNIM.ELOAD(ielem,2) = -factr;
        end
    end
    
    % --- Soma com TLOAD: ELOAD = ELOAD + TLOAD
    for ielem = 1:UNIM.NELEM
        for ievab = 1:UNIM.NEVAB
            UNIM.ELOAD(ielem, ievab) = UNIM.ELOAD(ielem, ievab) + UNIM.TLOAD(ielem, ievab);
        end
    %% 
    end
    
        end
    
        % 11) Verificar convergência do critério viscoplástico
        function UNIM = convp(UNIM)
    % CONVP - verifica convergência do critério viscoplástico (conversão direta)
    % Entradas/saídas: UNIM (struct com campos necessários: VIVEL, DTIME, ISTEP, FIRST,
    %                  PVALU, TOLER, PVALU, TTIME, NCHEK, NELEM)
    %
    % Observação: função assume que os campos existem e têm tamanhos compatíveis.

% inicializa indicador
UNIM.NCHEK = 1;
TOTAL=0.0;

% soma total = sum |VIVEL(i)| * DTIME
TOTAL = sum(abs(UNIM.VIVEL(1:UNIM.NELEM))) * UNIM.DTIME;

% guarda primeira soma se for o primeiro step do incremento
if UNIM.ISTEP == 1
    UNIM.FIRST = TOTAL;
end

% calcula razão percentual
if UNIM.FIRST == 0.0
    RATIO = 0.0;
else
    RATIO = 100.0 * TOTAL / UNIM.FIRST;
end

% critérios de convergência
if RATIO <= UNIM.TOLER
    UNIM.NCHEK = 0;
end

UNIM.PVALU=0.0;
if RATIO > UNIM.PVALU
    UNIM.NCHEK = 999;
end

% atualiza histórico de p-valor
UNIM.PVALU = RATIO;

% imprime resultados (equivalente aos WRITE do Fortran)
fprintf('     TOTAL TIME = %17.6e\n', UNIM.TTIME);
fprintf('     CONVERGENCE CODE = %4d   NORM OF RESIDUAL SUM RATIO = %14.6e\n', UNIM.NCHEK, RATIO);

end
 
    % 12) Verificar convergência do critério viscoplástico
    function UNIM = result(UNIM)
    % RESULT - outputs displacements, reactions and stresses (conversão de FORTRAN)
    % Uso: UNIM = result(UNIM);
    % Assume que UNIM contém: NPOIN, NELEM, NDOFN, TDISP, TREAC, STRES, PLAST

% Cabeçalhos para deslocamentos/reações
if UNIM.NDOFN == 1
    fprintf('\n    NODE     DISPL.           REACTIONS\n');
elseif UNIM.NDOFN == 2
    fprintf('\n    NODE     DISPL.      REACTION      DISPL.      REACTION\n');
else
    fprintf('\n    NODE'); 
    for idof = 1:UNIM.NDOFN
        fprintf('    DISPL(%d)     REACT(%d)', idof, idof);
    end
    fprintf('\n');
end

% Linhas por nó
for ipoin = 1:UNIM.NPOIN
    % imprime número do nó
    fprintf('%10d', ipoin);
    % imprime pares (TDISP, TREAC) para cada grau de liberdade do nó
    for idofn = 1:UNIM.NDOFN
        fprintf('%14.6e   %14.6e', UNIM.TDISP(ipoin, idofn), UNIM.TREAC(ipoin, idofn));
    end
    fprintf('\n');
end

% Cabeçalho para tensões e deformação plástica por elemento
if UNIM.NDOFN == 2
    fprintf('\n  ELEMENT      STRESSES            PL.STRAIN\n');
elseif UNIM.NDOFN == 1
    fprintf('\n  ELEMENT      STRESSES     PL.STRAIN\n');
else
    fprintf('\n  ELEMENT    STRESSES...    PL.STRAIN\n');
end

% Linhas por elemento
for ielem = 1:UNIM.NELEM
    % imprime número do elemento
    fprintf('%10d', ielem);
    % imprime componentes de STRES para IDOFN=1..NDOFN
    for idofn = 1:UNIM.NDOFN
        fprintf('%14.6e', UNIM.STRES(ielem, idofn));
    end
    % imprime PLAST do elemento
    fprintf('%14.6e\n', UNIM.PLAST(ielem));
end

end
