SUBROUTINE NONAL
   USE COMMON
   implicit none
!***********************************************************************
!******* SETS INDICATOR TO IDENTIFY TYPE OF SOLUTION ALGORITHM *********
!***********************************************************************

   ! Default mode is viscoplastic in the undeformed position
   KRESL = 2  !Sets default indicator for linear solution
   HRESL = 2  !Sets default indicator for material solution  
              !Sets default indicator for posititional solution  

   if (NALGO == 1) KRESL = 1
   if (NALGO == 2) KRESL = 1
   if (NALGO == 3 .and. IINCS == 1 .and. ISTEP == 1) KRESL = 1
   if (NALGO == 4 .and. ISTEP == 1) KRESL = 1
   if (NALGO == 5 .and. IINCS == 1 .and. ISTEP == 1) KRESL = 1
   if (NALGO == 6 .and. ISTEP == 2) KRESL = 1
   
   if (HALGO == 0) HRESL = 0
   if (HALGO == 1) HRESL = 1
   if (HALGO == 3) HRESL = 3

   if (ISTEP == 1 .or. NALGO == 1) then
      do ISVAB = 1, NSVAB
         FIXED(ISVAB) = PEFIX(ISVAB) * FACTO
      end do
   else

      do ISVAB = 1, NSVAB
         FIXED(ISVAB) = 0.0
      end do
   end if
   
END SUBROUTINE NONAL