SUBROUTINE RESULT
    use COMMON
    implicit none
!********************************************************************
! *** OUTPUTS DISPLACEMENT , REACTIONS AND STRESSES
!********************************************************************
    
!     PRINT NODAL DISPLACEMENTS AND REACTIONS
    if (NDOFN == 1 .AND. IINCS <= NINCS) then
        write(*,'(5X,"NODE",4X,"DISPL.",12X,"REACTIONS")')
    else if (NDOFN == 2 .AND. IINCS < NINCS) then
        write(*,'(5X,"NODE",4X,"DISPL.",13X,"REACTION",6X,"DISPL.",13X,"REACTION")')
        do IPOIN = 1, NPOIN
            write(*,'(I10,2(E14.6,5X,E14.6))') IPOIN, (TDISP(IPOIN,IDOFN), TREAC(IPOIN,IDOFN), IDOFN=1,NDOFN)
        end do
    end if
        
    !   PRINT ELEMENT STRESSES AND NON LINEAR STRAIN
    if (HALGO == 0 .AND. IINCS <= NINCS) then
        write(*,'(5X,"ELEM.",4X,"STRESSES",10X,"DEFORM.")')
        do IELEM = 1, NELEM
            write(*,'(I10,E14.6,5X,E14.6)') IELEM, STRES(IELEM), TSTRN(IELEM)
        end do
    end if
        
!   PRINT ELEMENT STRESSES AND PLASTIC STRAIN
    if (HALGO == 2 .AND. IINCS <= NINCS) then
        write(*,'(5X,"ELEM.",4X,"STRESSES",10X,"DEFORM.",10x,"PL.STRAIN",10X,"DASHPOT")')
        do IELEM = 1, NELEM
            write(*,'(I10,4(E14.6,5X))') IELEM, STRES(IELEM), TSTRN(IELEM), PLAST(IELEM), DASH1(IELEM)
        end do
    end if
       
!   PRINT ELEMENT STRESSES AND FLUENCE STRAIN
    if ((HALGO == 1 .OR. HALGO ==3) .AND. IINCS <= NINCS) then
        write(*,'(5X,"ELEM.",4X,"STRESSES",10X,"DEFORM.",7X,"CREEP",14X,"DASHPOT",7X,"SIGMA1")')
        do IELEM = 1, NELEM
            write(*,'(I10,E14.6,5X,E14.6,E14.6,5X,E14.6,E14.6)') IELEM, STRES(IELEM), TSTRN(IELEM), FLUEN(IELEM), DASH1(IELEM), SIGM1(IELEM)
        end do
    end if
    
!********************************************************************
! *** EQUILIBRIUM PATH OUTPUT FOR POST-PROCESSING
!********************************************************************
    
    if (EPATH ==1) then
        RFOOT(IINCS) = -(TLOAD(1,4) + TLOAD(2,2))
        UNODE(IINCS) = -TDISP(2,2)
        !call Sleep(3)
    end if
    
    if (IINCS ==NINCS) STOP1 = 1
    if (EPATH == 1 .AND. STOP1 == 1) then
        ! Output file for equilibrium path
        write(FNAME,'(A,I0,A)') "saida_", IMODE, ".txt"
        GUNIT = 20 ! + ID only for //
        open(unit=GUNIT, file=FNAME, status="unknown")

        do JINCS = 1, MINCS
            write(GUNIT,'(F12.6,10X,F12.6)') RFOOT(JINCS), UNODE(JINCS)
        end do
        close(GUNIT)
        STOP1 = 1
        write(*,'(//,1X,"EQUILIBRIUM PATH FILE GENERATED: ",A)') FNAME
    end if
    !if (stop1 == 1) call Sleep(3000)

END SUBROUTINE RESULT
