SUBROUTINE INCLOD
    USE COMMON
    implicit none
!***********************************************************************
! *** INPUTS DATA FOR CURRENT INCREMENT AND UPDATES LOAD VECTOR
!***********************************************************************
     
    read(1,*)label, NSTEP,label, NOUTP,label, FACTO,label,TOLER
    
!  WRITE PARAMETERS
   write(*,'(///,1X,"IINCS =",I5,3X,"NSTEP =",I5,3X,"NOUTP =",I5, &
             3X,"FACTO =",E14.6,3X,"TOLER =",E14.6)') IINCS, NSTEP, NOUTP, FACTO, TOLER

!  UPDATE ELEMENT LOADS
   do IELEM = 1, NELEM
      do IEVAB = 1, NEVAB
         ELOAD(IELEM, IEVAB) = ELOAD(IELEM, IEVAB) + RLOAD(IELEM, IEVAB) * FACTO
         TLOAD(IELEM, IEVAB) = TLOAD(IELEM, IEVAB) + RLOAD(IELEM, IEVAB) * FACTO
      end do
   end do

!  UPDATE COORDINATES WITH DISPLACEMENTS
    do  INODE=1, NNODE
        IPOIN=(INODE-1)*NDOFN+1
        COORD(INODE,1) = COORD(INODE,1) + XDISP(IPOIN)
        COORD(INODE,2) = COORD(INODE,2) + XDISP(IPOIN+1)
    end do
END SUBROUTINE INCLOD