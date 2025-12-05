SUBROUTINE RESULT
    USE COMMON
    implicit none
!********************************************************************
! *** OUTPUTS DISPLACEMENT , REACTIONS AND STRESSES
!********************************************************************

!     PRINT NODAL DISPLACEMENTS AND REACTIONS
    if (NDOFN == 1) then
        write(*,'(5X,"NODE",4X,"DISPL.",12X,"REACTIONS")')
    else if (NDOFN == 2) then
        write(*,'(5X,"NODE",4X,"DISPL.",13X,"REACTION",6X,"DISPL.",13X,"REACTION")')
    end if

    do IPOIN = 1, NPOIN
        write(*,'(I10,2(E14.6,5X,E14.6))') IPOIN, (TDISP(IPOIN,IDOFN), TREAC(IPOIN,IDOFN), IDOFN=1,NDOFN)
    end do

!   PRINT ELEMENT STRESSES AND PLASTIC STRAIN
    if (HALGO == 2 ) then
        write(*,'(5X,"ELEM.",4X,"STRESSES",10X,"DEFORM.",7X,"PL.STRAIN",10X,"DASHPOT")')
        do IELEM = 1, NELEM
            write(*,'(I10,2(E14.6,5X,E14.6)))') IELEM, STRES(IELEM), TSTRN(IELEM), PLAST(IELEM),DASH1(IELEM)
        end do
    end if
   
!   PRINT ELEMENT STRESSES AND FLUENCE STRAIN
    if (HALGO == 1 .OR. HALGO ==3 ) then
        write(*,'(5X,"ELEM.",4X,"STRESSES",10X,"DEFORM.",7X,"CREEP",14X,"DASHPOT",7X,"SIGMA1")')
        do IELEM = 1, NELEM
            write(*,'(I10,2E30.15,5X,E14.6,2E14.6,5X,E14.6,E14.6)') IELEM, STRES(IELEM), TSTRN(IELEM), FLUEN(IELEM),DASH1(IELEM),SIGM1(IELEM)
        end do
    end if
    

    
END SUBROUTINE RESULT