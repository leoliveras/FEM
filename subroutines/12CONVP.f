      SUBROUTINE CONVP
C***********************************************************************
C
C *** CHECKS FOR SOLUTION CONVERGENCE
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
    
    
      NCHEK = 1
      TOTAL = 0.0

      DO 10 IELEM = 1, NELEM
  10   TOTAL = TOTAL + ABS(VIVEL(IELEM))*DTIME
      IF (ISTEP .EQ. 1) FIRST = TOTAL
      IF (FIRST .EQ. 0.0) GO TO 20
      RATIO = 100.0 * TOTAL / FIRST
      GO TO 30
  20  RATIO = 0.0
  30  CONTINUE
      IF (RATIO .LE. TOLER) NCHEK = 0
      IF (RATIO .GT. PVALU) NCHEK = 999
  40  PVALU=RATIO
      WRITE(6,900) TTIME
  900 FORMAT(1H0,5X,12HTOTAL TIME =,E17.6)
      WRITE(6,910) NCHEK, RATIO
  910 FORMAT(1H0,5X,18HCONVERGENCE CODE =,I4,3X,
     *       28HNORM OF RESIDUAL SUM RATIO =,E14.6)
      RETURN
      END