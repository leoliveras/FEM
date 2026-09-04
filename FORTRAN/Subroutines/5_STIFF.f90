SUBROUTINE STIFF
      use COMMON
      use STRDFN
      use STRNFN
      implicit none
      
      REAL(8)::DBG_ELENG, DBG_STRCH
!***********************************************************************
! *** CALCULATES ELEMENT STIFFNESS MATRICES
!***********************************************************************
if (GALGO == 0) then
        do IELEM = 1, NELEM
            LPROP = MATNO(IELEM)
            XAREA(IELEM) = PROPS(LPROP,1)
            YOUNG(IELEM) = PROPS(LPROP,2)
    
            if (NPROP >= 4) then
                YIELD(IELEM) = PROPS(LPROP,3)
                HARDS(IELEM) = PROPS(LPROP,4)
            end if
        
            if (NPROP >= 5) then
                GAMMA(IELEM) = PROPS(LPROP,5)
            end if
        
            if (NPROP >= 8) then
                YONG0(IELEM) = PROPS(LPROP,6)
                GAMA1(IELEM) = PROPS(LPROP,7)
                YONG1(IELEM) = PROPS(LPROP,8)
            end if

            NODE1 = LNODS(IELEM,1)
            NODE2 = LNODS(IELEM,2)
            XPOT1 = COORD(NODE1,1)
            YPOT1 = COORD(NODE1,2)
            XPOT2 = COORD(NODE2,1)
            YPOT2 = COORD(NODE2,2)
            DELTX = XPOT2 - XPOT1
            DELTY = YPOT2 - YPOT1
            ELENG(IELEM) = SQRT(DELTX*DELTX + DELTY*DELTY)
      

            ! direction cosines
            CALFA(IELEM) = DELTX / ELENG(IELEM)
            SALFA(IELEM) = DELTY / ELENG(IELEM)
      
            FMULT = YOUNG(IELEM) * XAREA(IELEM) / ELENG(IELEM) 
        
            if (HRESL == 0 ) then
                FMULT = FMULT * STDIV(STRCH)
            end if 
        
            DBG_STRCH= STRCH
        
            if (HRESL == 1 ) then
                if (PLAST(IELEM) > 0.0) FMULT = FMULT*(1.0-YOUNG(IELEM)/(YOUNG(IELEM)+HARDS(IELEM)))
            end if 
        

            ! element stiffness matrix (4x4)
            ESTIF(IELEM,1,1) =  FMULT*CALFA(IELEM)*CALFA(IELEM)
            ESTIF(IELEM,1,2) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,1,3) = -FMULT*CALFA(IELEM)*CALFA(IELEM)
            ESTIF(IELEM,1,4) = -FMULT*CALFA(IELEM)*SALFA(IELEM)

            ESTIF(IELEM,2,1) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,2,2) =  FMULT*SALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,2,3) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,2,4) = -FMULT*SALFA(IELEM)*SALFA(IELEM)

            ESTIF(IELEM,3,1) = -FMULT*CALFA(IELEM)*CALFA(IELEM)
            ESTIF(IELEM,3,2) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,3,3) =  FMULT*CALFA(IELEM)*CALFA(IELEM)
            ESTIF(IELEM,3,4) =  FMULT*CALFA(IELEM)*SALFA(IELEM)

            ESTIF(IELEM,4,1) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,4,2) = -FMULT*SALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,4,3) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
            ESTIF(IELEM,4,4) =  FMULT*SALFA(IELEM)*SALFA(IELEM)

        end do
  
    elseif (GALGO ==1) then
            do  IELEM = 1, NELEM
                LPROP = MATNO(IELEM)
                XAREA(IELEM) = PROPS(LPROP,1)
                YOUNG(IELEM) = PROPS(LPROP,2)

                NODE1 = LNODS(IELEM,1)
                NODE2 = LNODS(IELEM,2)
                XPOT1 = COORD(NODE1,1) + TDISP(NODE1, 1)
                YPOT1 = COORD(NODE1,2) + TDISP(NODE1, 2)
                XPOT2 = COORD(NODE2,1) + TDISP(NODE2, 1)
                YPOT2 = COORD(NODE2,2) + TDISP(NODE2, 2)
                DELTX = XPOT2 - XPOT1
                DELTY = YPOT2 - YPOT1
                ELENG(IELEM) = SQRT(DELTX*DELTX + DELTY*DELTY)
                if (IINCS==1 .AND. ISTEP==1) LENG0(IELEM) = ELENG(IELEM) 
                LTRIL = sqrt(DELTX*DELTX + DELTY*DELTY)
                  
                STRCH = LTRIL / LENG0(IELEM)
                if (HRESL == 0) then
                    FMULT = YOUNG(IELEM)*XAREA(IELEM)/LENG0(IELEM)
                end if 
        
                DBG_STRCH= STRCH      
                !-------------------------------------------------------
                ! STIFFNESS MATRIX - LARGE DEFORMATION
                !-------------------------------------------------------
                ESTIF(IELEM,1,1) = FMULT*((DELTX/LENG0(IELEM))**2 + STNFN(STRCH))
                ESTIF(IELEM,1,2) = FMULT*(DELTX/LENG0(IELEM))*(DELTY/LENG0(IELEM))
                ESTIF(IELEM,1,3) =-ESTIF(IELEM,1,1)
                ESTIF(IELEM,1,4) =-ESTIF(IELEM,1,2)

                ESTIF(IELEM,2,1) = ESTIF(IELEM,1,2)
                ESTIF(IELEM,2,2) = FMULT*((DELTY/LENG0(IELEM))**2 + STNFN(STRCH))
                ESTIF(IELEM,2,3) =-ESTIF(IELEM,1,2)
                ESTIF(IELEM,2,4) =-ESTIF(IELEM,2,2)

                ESTIF(IELEM,3,1) =-ESTIF(IELEM,1,1)
                ESTIF(IELEM,3,2) =-ESTIF(IELEM,1,2)
                ESTIF(IELEM,3,3) = ESTIF(IELEM,1,1)
                ESTIF(IELEM,3,4) = ESTIF(IELEM,1,2)

                ESTIF(IELEM,4,1) =-ESTIF(IELEM,1,2)
                ESTIF(IELEM,4,2) =-ESTIF(IELEM,2,2)
                ESTIF(IELEM,4,3) = ESTIF(IELEM,1,2)
                ESTIF(IELEM,4,4) = ESTIF(IELEM,2,2) 

            end do
      end if

END SUBROUTINE STIFF


