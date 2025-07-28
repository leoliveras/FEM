      SUBROUTINE STUNVP
C***********************************************************************
C
C *** CALCULATES ELEMENT STIFFNESS MATRICES
C
C***********************************************************************

      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,ISTEP,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NSTEP,NOUTP,FACTO,TAUFT,DTINT,FTIME,FIRST,PVALU,
     *             DTIME,TTIME
      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4),VIVEL(25)
    
      REWIND 1
      DO 10 IELEM = 1, NELEM
       LPROP = MATNO(IELEM)
       YOUNG = PROPS(LPROP,1)
       XAREA = PROPS(LPROP,2)
       NODE1 = LNODS(IELEM,1)
       NODE2 = LNODS(IELEM,2)
       ELENG = ABS(COORD(NODE1) - COORD(NODE2))
       FMULT = YOUNG * XAREA / ELENG
       ESTIF(1,1) = FMULT
       ESTIF(1,2) = -FMULT
       ESTIF(2,1) = -FMULT
       ESTIF(2,2) = FMULT
       WRITE(1) ESTIF
10    CONTINUE

      RETURN
      END