      SUBROUTINE NONAL
C***********************************************************************
C
C******* SETS INDICATOR TO IDENTIFY TYPE OF SOLUTION ALGORITHM *********
C
C***********************************************************************

      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,ISTEP,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NITER,NOUTP,FACTO,PVALU
     
      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4)
    
      KRESL = 2

      IF(NALGO.EQ.1) KRESL = 1
      IF(NALGO.EQ.2) KRESL = 1
      IF(NALGO.EQ.3 .AND. IINCS.EQ.1 .AND. ISTEP.EQ.1) KRESL = 1
      IF(NALGO.EQ.4 .AND. ISTEP.EQ.1) KRESL = 1
      IF(NALGO.EQ.5 .AND. IINCS.EQ.1 .AND. ISTEP.EQ.1) KRESL = 1
      IF(NALGO.EQ.6 .AND. ISTEP.EQ.2) KRESL = 1

      IF(ISTEP.EQ.1 .OR. NALGO.EQ.1) GO TO 20

      DO 10 ISVAB = 1, NSVAB
   10 FIXED(ISVAB) = 0.0
      RETURN

   20 DO 30 ISVAB = 1, NSVAB
   30 FIXED(ISVAB) = PEFIX(ISVAB) * FACTO

      RETURN
      END
