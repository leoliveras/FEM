SUBROUTINE BAKSUB
      USE COMMON
      implicit none
!***********************************************************************
!*** BACK-SUBSTITUTION ROUTINE
!***********************************************************************

   NEQNS = NSVAB

   ! Initialize reaction vector
   REACT = 0.0

   NEQN1 = NEQNS + 1
   do IEQNS = 1, NEQNS
      NBACK = NEQN1 - IEQNS
      PIVOT = ASTIF(NBACK, NBACK)
      RESID = ASLOD(NBACK)

      if (NBACK /= NEQNS) then
         NBAC1 = NBACK + 1
         do ICOLS = NBAC1, NEQNS
            RESID = RESID - ASTIF(NBACK, ICOLS) * XDISP(ICOLS)
         end do
      end if

      if (IFPRE(NBACK) == 0) then
         XDISP(NBACK) = RESID / PIVOT
      else
         XDISP(NBACK) = FIXED(NBACK)
         REACT(NBACK) = -RESID
      end if
   end do

   ! Update total displacements and reactions
   KOUNT = 0
   do IPOIN = 1, NPOIN
      do IDOFN = 1, NDOFN
         KOUNT = KOUNT + 1
         TDISP(IPOIN, IDOFN) = TDISP(IPOIN, IDOFN) + XDISP(KOUNT)
         TREAC(IPOIN, IDOFN) = TREAC(IPOIN, IDOFN) + REACT(KOUNT)
      end do
   end do

   ! Assemble nodal reactions into element loads
   do IPOIN = 1, NPOIN
      do IELEM = 1, NELEM
         do INODE = 1, NNODE
            NLOCA = LNODS(IELEM, INODE)
            if (IPOIN == NLOCA) then
               do IDOFN = 1, NDOFN
                  NPOSN = (IPOIN - 1) * NDOFN + IDOFN
                  IEVAB = (INODE - 1) * NDOFN + IDOFN
                  TLOAD(IELEM, IEVAB) = TLOAD(IELEM, IEVAB) + REACT(NPOSN)
               end do
            end if
         end do
      end do
   end do



      END
    