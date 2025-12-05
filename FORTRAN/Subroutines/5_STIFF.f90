SUBROUTINE STIFF
      USE COMMON
      implicit none
!***********************************************************************
! *** CALCULATES ELEMENT STIFFNESS MATRICES
!***********************************************************************

   rewind(10)

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
        
        !if (HRESL == 0 ) then
        !    PTRAN = TSTRN(IELEM)
        !    FMULT = FMULT * STDFN(PTRAN)
        !end if 

        ! element stiffness matrix (4x4)
        ESTIF(1,1) =  FMULT*CALFA(IELEM)*CALFA(IELEM)
        ESTIF(1,2) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(1,3) = -FMULT*CALFA(IELEM)*CALFA(IELEM)
        ESTIF(1,4) = -FMULT*CALFA(IELEM)*SALFA(IELEM)

        ESTIF(2,1) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(2,2) =  FMULT*SALFA(IELEM)*SALFA(IELEM)
        ESTIF(2,3) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(2,4) = -FMULT*SALFA(IELEM)*SALFA(IELEM)

        ESTIF(3,1) = -FMULT*CALFA(IELEM)*CALFA(IELEM)
        ESTIF(3,2) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(3,3) =  FMULT*CALFA(IELEM)*CALFA(IELEM)
        ESTIF(3,4) =  FMULT*CALFA(IELEM)*SALFA(IELEM)

        ESTIF(4,1) = -FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(4,2) = -FMULT*SALFA(IELEM)*SALFA(IELEM)
        ESTIF(4,3) =  FMULT*CALFA(IELEM)*SALFA(IELEM)
        ESTIF(4,4) =  FMULT*SALFA(IELEM)*SALFA(IELEM)

      write(10) ESTIF
   end do



END SUBROUTINE STIFF


