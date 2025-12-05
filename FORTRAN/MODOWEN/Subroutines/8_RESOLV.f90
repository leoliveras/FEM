SUBROUTINE RESOLV
      USE COMMON
      implicit none
!***********************************************************************
!***  RESOLVING GAUSSIAN REDUCTION ROUTINE                 
!***********************************************************************
     
   KOUNT = 0
   NEQNS = NSVAB

   do IEQNS = 1, NEQNS
      if (IFPRE(IEQNS) == 1) then
!
!     ADJUST RHS TO PRESCRIBED DISPLACEMENTS
!
         do IROWS = IEQNS, NEQNS
            ASLOD(IROWS) = ASLOD(IROWS) - ASTIF(IROWS, IEQNS) * FIXED(IEQNS)
         end do
      else
!
!     REDUCE RHS
!
         if (IEQNS /= NEQNS) then
            IEQN1 = IEQNS + 1
            do IROWS = IEQN1, NEQNS
               KOUNT = KOUNT + 1
               FACTR = FRESV(KOUNT)
               if (FACTR /= 0.0d0) then
                  ASLOD(IROWS) = ASLOD(IROWS) - FACTR * ASLOD(IEQNS)
               end if
            end do
         end if
      end if
   end do

END SUBROUTINE RESOLV
    