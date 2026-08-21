SUBROUTINE INCVEP
   use COMMON
   implicit none
!***********************************************************************
!******* SETS INDICATOR TO IDENTIFY NONLINEAR MATERIAL  TYPE ***********
!***********************************************************************

   if (HRESL == 0) CALL REFOR2
   
   if (HRESL == 1) CALL REFOR3
   
   if (HRESL == 2) CALL INCVP
      
   if (HRESL == 3) CALL INCKV
   
   if (HRESL == 4) CALL INCVE
   
   
END SUBROUTINE INCVEP
