SUBROUTINE STIFF
      use COMMON
      use STRDFN
      implicit none
!***********************************************************************
! *** CALCULATES ELEMENT STIFFNESS MATRICES
!***********************************************************************

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
            STRCH = TSTRN(IELEM)
            FMULT = FMULT * STDIV(STRCH)
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

END SUBROUTINE STIFF


