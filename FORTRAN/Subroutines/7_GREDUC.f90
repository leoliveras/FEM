
SUBROUTINE GREDUC
      USE COMMON
      implicit none
!***********************************************************************
!                     GAUSSIAN REDUCTION ROUTINE
!***********************************************************************


!   
!     GAUSSIAN REDUCTION ROUTINE
!
          KOUNT = 0
          NEQNS = NSVAB
    
      do IEQNS = 1, NEQNS
            if (IFPRE(IEQNS) == 1) then
!    
!     ADJUST RHS (LOADS) FOR PRESCRIBED DISPLACEMENTS
!
                  do IROWS = IEQNS, NEQNS
                        ASLOD(IROWS) = ASLOD(IROWS) - ASTIF(IROWS, IEQNS) * FIXED(IEQNS)
                  end do
                  cycle
            end if

!    
!     REDUCE EQUATIONS
!
            PIVOT = ASTIF(IEQNS, IEQNS)
            if (abs(PIVOT) < 1.0d-10) then
               write(*,'(5X,"!! INCORRECT PIVOT")')
               stop
            end if

            if (IEQNS == NEQNS) cycle

            IEQN1 = IEQNS + 1
            do IROWS = IEQN1, NEQNS
                  KOUNT = KOUNT + 1
                  FACTR = ASTIF(IROWS, IEQNS) / PIVOT
                  FRESV(KOUNT) = FACTR
                  if (FACTR == 0.0d0) cycle

                  do ICOLS = IEQNS, NEQNS
                        ASTIF(IROWS, ICOLS) = ASTIF(IROWS, ICOLS) - FACTR * ASTIF(IEQNS, ICOLS)
                  end do

                  ASLOD(IROWS) = ASLOD(IROWS) - FACTR * ASLOD(IEQNS)
             end do
          end do

END SUBROUTINE GREDUC