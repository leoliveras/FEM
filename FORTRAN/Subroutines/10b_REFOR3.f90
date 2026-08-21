SUBROUTINE REFOR3

    use COMMON
    implicit none

!***********************************************************************
!*** CALCULA FORCAS INTERNAS EQUIVALENTES
!*** MODELO ELASTOPLASTICO COM ENCRUAMENTO LINEAR
!***********************************************************************

    ! ZERA AS CARGAS INTERNAS DOS ELEMENTOS
    ELOAD(:,:) = 0.0D0

    ! LOOP NOS ELEMENTOS
    do IELEM = 1, NELEM
        LPROP = MATNO(IELEM)
        
        NODE1 = LNODS(IELEM,1)
        NODE2 = LNODS(IELEM,2)

        XPOT1 = COORD(NODE1,1)
        YPOT1 = COORD(NODE1,2)
        XPOT2 = COORD(NODE2,1)
        YPOT2 = COORD(NODE2,2)

        DELTX = XPOT2 - XPOT1
        DELTY = YPOT2 - YPOT1

        ELENG(IELEM) = SQRT(DELTX*DELTX + DELTY*DELTY)

        ! COSSENOS DIRETORES
        CALFA(IELEM) = DELTX / ELENG(IELEM)
        SALFA(IELEM) = DELTY / ELENG(IELEM)

        ! DESLOCAMENTOS AXIAIS LOCAIS DOS NOS
        DISP1 = CALFA(IELEM)*XDISP(2*NODE1-1) + &
                SALFA(IELEM)*XDISP(2*NODE1)

        DISP2 = CALFA(IELEM)*XDISP(2*NODE2-1) + &
                SALFA(IELEM)*XDISP(2*NODE2)

        ! DEFORMACAO AXIAL INCREMENTAL
        STRAN(IELEM) = (DISP2 - DISP1) / ELENG(IELEM)
        TSTRN(IELEM) = TSTRN(IELEM) + STRAN(IELEM)
        
        ! INCREMENTO DE TENSAO ELASTICO TENTATIVO
        STLIN = YOUNG(IELEM) * STRAN(IELEM)

        ! TENSAO TENTATIVA (STRES contem a tensao acumulada do elemento antes deste incremento)
        STCUR = STRES(IELEM) + STLIN

        !-----------------------------------------------------------------------
        ! TENSAO DE ESCOAMENTO ATUAL
        !
        ! sigma_y = sigma_y0 + H * |epsilon_p|
        !-----------------------------------------------------------------------
        PREYS = YIELD(IELEM) + HARDS(IELEM) * abs(PLAST(IELEM))

        !-----------------------------------------------------------------------
        ! FUNCAO DE ESCOAMENTO
        !
        ! ESCUR <= 0  -> elastico
        ! ESCUR >  0  -> plastico
        !-----------------------------------------------------------------------

        ESCUR = ABS(STCUR) - PREYS
        ! write(*,'(A,I4,F12.6)') 'Elemento:', IELEM, PREYS

        ! DETERMINACAO DO FATOR PLASTICO
        RFACT = 0.0D0
        if (STRES(IELEM) < PREYS) then
            if (ESCUR <= 0) then
                RFACT = 0.d0
            else 
                RFACT=ESCUR/ABS(STLIN)
            end if 
        elseif (STRES(IELEM)<0 .OR. STRES(IELEM)>0) then
            RFACT=1.0
        end if

        ! REGIME ELASTICO
        if (RFACT == 0.0D0) then
            STRES(IELEM) = STRES(IELEM) + STLIN
        
        ! ATUALIZACAO ELASTOPLASTICA
        else    
            REDUC = 1.0D0 - RFACT
!           Parte elastica ate atingir o escoamento
!           + parte elastoplastica apos o escoamento
            if (ESCUR > 0.0D0) then
                ! incremento plástico escalar (sempre positivo)
                PLAST(IELEM) = PLAST(IELEM) + ESCUR / (YOUNG(IELEM) + HARDS(IELEM))
                STRES(IELEM) = SIGN(1.0D0, STCUR) * (YIELD(IELEM) + HARDS(IELEM)*PLAST(IELEM))
            else
                ! descarregamento: só elástico
                STRES(IELEM) = STCUR
            end if
        end if 
        
        
        ! FORCA AXIAL DO ELEMENTO
        FACTR = STRES(IELEM) * XAREA(IELEM)
        !-----------------------------------------------------------------------
        ! FORCAS NODAIS EQUIVALENTES EM COORDENADAS GLOBAIS
        !-----------------------------------------------------------------------
        ELOAD(IELEM,1) = -FACTR * CALFA(IELEM)
        ELOAD(IELEM,2) = -FACTR * SALFA(IELEM)

        ELOAD(IELEM,3) =  FACTR * CALFA(IELEM)
        ELOAD(IELEM,4) =  FACTR * SALFA(IELEM)
    end do
    
    return
END SUBROUTINE REFOR3