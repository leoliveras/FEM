SUBROUTINE INCVP
      USE COMMON
      implicit none
!***********************************************************************
! *** CALCULATES INTERNAL EQUIVALENT NODAL FORCES
!***********************************************************************
 
!  ZEROS ELOAD 
   ELOAD = 0.0d0

   DNEXT = FTIME * DTIME

! LOOP OF THE ELEMENTS
   do IELEM = 1, NELEM
! *** Stage 1
!     a)  Displacements, strain, stress, plastification in n-step
      
      NODE1 = LNODS(IELEM,1)
      NODE2 = LNODS(IELEM,2)
      DISP1 = CALFA(IELEM)*XDISP(2*NODE1-1) + SALFA(IELEM)*XDISP(2*NODE1)
      DISP2 = CALFA(IELEM)*XDISP(2*NODE2-1) + SALFA(IELEM)*XDISP(2*NODE2)

      DSPGX = sqrt(XDISP(2*NODE2-1)**2 + XDISP(2*NODE1-1)**2)
      DSPGY = sqrt(XDISP(2*NODE2)**2   + XDISP(2*NODE1)**2)
            
      STRAN = (DISP2 - DISP1) / ELENG(IELEM)
      TSTRN = TSTRN + STRAN
      
      DASH1(IELEM)= STRES(IELEM) - (YIELD(IELEM) + HARDS(IELEM) * PLAST(IELEM))
          
      STRES(IELEM) = STRES(IELEM) + (STRAN(IELEM) - VIVEL(IELEM) * DTIME) * YOUNG(IELEM)
      PLAST(IELEM)   = PLAST(IELEM)   + VIVEL(IELEM) * DTIME

!     b) Plastification rate, preys in (n+1)-step
      IF(STRES(IELEM) < 0.0) YIELD(IELEM) = -YIELD(IELEM)
      PREYS = YIELD(IELEM) + HARDS(IELEM) * PLAST(IELEM)

      if (abs(STRES(IELEM)) > abs(PREYS)) then
          VIVEL(IELEM) = GAMMA(IELEM) * (STRES(IELEM) - (YIELD(IELEM) + HARDS(IELEM) * PLAST(IELEM)))
      else
        VIVEL(IELEM) = 0.0d0
      end if

!***  Limiting time-step length 
      DELTM = TAUFT * abs(TSTRN(IELEM) / VIVEL(IELEM))
      if (DELTM < DNEXT) DNEXT = DELTM
    
   end do

   DTIME = DNEXT
   if (ISTEP == 1) DTIME = DTINT
!    
! CALCULO DAS FORÇAS INTERNAS
!
   do IELEM = 1, NELEM

      FACTR = (YOUNG(IELEM) * VIVEL(IELEM) * DTIME - STRES(IELEM)) * XAREA(IELEM)

      ELOAD(IELEM,1) = -FACTR*CALFA(IELEM)
      ELOAD(IELEM,2) = -FACTR*SALFA(IELEM)
      ELOAD(IELEM,3) =  FACTR*CALFA(IELEM)
      ELOAD(IELEM,4) =  FACTR*SALFA(IELEM)
   end do

!
! SUM WITH TLOAD
!
   do IELEM = 1, NELEM  
      do IEVAB = 1, NEVAB
         ELOAD(IELEM,IEVAB) = ELOAD(IELEM,IEVAB) + TLOAD(IELEM,IEVAB)
      end do
   end do

   

END SUBROUTINE INCVP