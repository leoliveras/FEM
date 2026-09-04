subroutine REFOR2
    use COMMON
    use STRNFN
    implicit none
    
    ELOAD = 0.d0

    do IELEM = 1, NELEM

        NODE1 = LNODS(IELEM,1)
        NODE2 = LNODS(IELEM,2)
 
        DISP1=CALFA(IELEM)*XDISP(2*NODE1-1)+SALFA(IELEM)*XDISP(2*NODE1)
        DISP2=CALFA(IELEM)*XDISP(2*NODE2-1)+SALFA(IELEM)*XDISP(2*NODE2)

        DSPGX=SQRT(XDISP(2*NODE2-1)**2+XDISP(2*NODE1-1)**2)
        DSPGY=SQRT(XDISP(2*NODE2)**2+XDISP(2*NODE1)**2)
         
        STRAN(IELEM) = (DISP2-DISP1)/ELENG(IELEM)
        TSTRN(IELEM) = TSTRN(IELEM) + STRAN(IELEM)

        if (GRESL == 0) STRCH = TSTRN(IELEM)
        if (GRESL == 1) then
            DXCUR = (COORD(NODE2,1) + TDISP(NODE2,1)) - &
                    (COORD(NODE1,1) + TDISP(NODE1,1))
            DYCUR = (COORD(NODE2,2) + TDISP(NODE2,2)) - &
                    (COORD(NODE1,2) + TDISP(NODE1,2))
            LTRIL = sqrt(DXCUR*DXCUR + DYCUR*DYCUR)
            STRCH = LTRIL / LENG0(IELEM)
        end if 
        
        STRES(IELEM) = YOUNG(IELEM)*STNFN(STRCH)
        
        
        if (GRESL == 0) FACTR = STRES(IELEM) * XAREA(IELEM)
        if (GRESL == 1) then
            FACTR = XAREA(IELEM)*STRES(IELEM)/LENG0(IELEM)
        end if
        
        if (GRESL == 0) then
            ELOAD(IELEM,1) = -FACTR*CALFA(IELEM)
            ELOAD(IELEM,2) = -FACTR*SALFA(IELEM)
            ELOAD(IELEM,3) =  FACTR*CALFA(IELEM)
            ELOAD(IELEM,4) =  FACTR*SALFA(IELEM)
        
        elseif (GRESL == 1) then
            ELOAD(IELEM,1) = -FACTR*DXCUR
            ELOAD(IELEM,2) = -FACTR*DYCUR

            ELOAD(IELEM,3) =  FACTR*DXCUR
            ELOAD(IELEM,4) =  FACTR*DYCUR
        end if 
        
    end do

    
END SUBROUTINE REFOR2
    
