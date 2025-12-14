SUBROUTINE INCVEP
   USE COMMON
   implicit none
!***********************************************************************
!******* SETS INDICATOR TO IDENTIFY NONLINEAR MATERIAL  TYPE ***********
!***********************************************************************

   if (HRESL == 0) CALL REDFOR
   
   if (HRESL == 1) CALL INCVE
   
   if (HRESL == 2) CALL INCVP
   
   if (HRESL == 3) CALL INCKV
   
END SUBROUTINE INCVEP
