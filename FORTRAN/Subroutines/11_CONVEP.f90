SUBROUTINE CONVEP
    use COMMON
    implicit none
!***********************************************************************
!*** CHECKS FOR SOLUTION CONVERGENCE
!***********************************************************************

    if (HRESL == 0 .or. HRESL == 1) call CONUND
    
    if (HRESL == 2 .or. HRESL == 3 .or. HRESL == 4) call CONVP

END SUBROUTINE CONVEP
