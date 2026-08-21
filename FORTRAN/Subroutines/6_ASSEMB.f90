SUBROUTINE ASSEMB
    USE COMMON
    implicit none
!************************************************************************
!***                   ELEMENT ASSEMBLY ROUTINE                         *
!************************************************************************

    if (KRESL /= 2) ASTIF = 0.d0
    ASLOD = 0.d0
    
!   ASSEMBLE THE ELEMENT LOADS

    do IELEM = 1, NELEM

          do INODE = 1, NNODE
                NODEI = LNODS(IELEM, INODE)
                do IDOFN = 1, NDOFN
                NROWS = (NODEI - 1) * NDOFN + IDOFN
                NROWE = (INODE - 1) * NDOFN + IDOFN
                ASLOD(NROWS) = ASLOD(NROWS) + ELOAD(IELEM, NROWE)

!               ASSEMBLE THE ELEMENT STIFFNESS MATRICES
                if (KRESL /= 2) then
                      do JNODE = 1, NNODE
                      NODEJ = LNODS(IELEM, JNODE)
                            do JDOFN = 1, NDOFN
                                  NCOLS = (NODEJ - 1) * NDOFN + JDOFN
                                  NCOLE = (JNODE - 1) * NDOFN + JDOFN
                                  ASTIF(NROWS, NCOLS) = ASTIF(NROWS, NCOLS) + &
                                                    ESTIF(IELEM,NROWE, NCOLE)
                            end do
                      end do
                end if

                end do
          end do
    end do

END SUBROUTINE ASSEMB
