SUBROUTINE CONVEP
    USE COMMON
    implicit none
!***********************************************************************
!*** CHECKS FOR SOLUTION CONVERGENCE
!***********************************************************************

    if (HRESL == 0) call CONUND
    
    if (HRESL /= 0) call CONVP


END SUBROUTINE CONVEP
