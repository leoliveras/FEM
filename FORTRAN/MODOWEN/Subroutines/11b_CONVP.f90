SUBROUTINE CONVP
    USE COMMON
    implicit none
!***********************************************************************
!*** CHECKS FOR SOLUTION CONVERGENCE
!***********************************************************************

    NCHEK = 1
    TOTAL  = 0.0d0

!   Sum of plasticity/fluence increments
    do IELEM = 1, NELEM
        TOTAL = TOTAL + abs(VIVEL(IELEM)) * DTIME
    end do

    if (ISTEP == 1) FIRST = TOTAL

    if (FIRST == 0.d0) then
        RATIO = 0.d0
    else
        RATIO = 100.0d0 * TOTAL / FIRST
    end if

    if (RATIO <= TOLER) NCHEK = 0
    if (RATIO > PVALU) NCHEK = 999
    PVALU = RATIO

    write(*,'(/,5X,"TOTAL TIME =",E17.6)') TTIME
    write(*,'(5X,"CONVERGENCE CODE =",I4,3X,"NORM OF RESIDUAL SUM RATIO =",E14.6)') NCHEK, RATIO


END SUBROUTINE CONVP