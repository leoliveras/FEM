      SUBROUTINE RESOLV
C***********************************************************************
C
C***  RESOLVING GAUSSIAN REDUCTION ROUTINE                 
C
C***********************************************************************
    
      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,IITER,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NITER,NOUTP,FACTO,PVALU
     
      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4)
     

        KOUNT = 0
        NEQNS = NSVAB
    
        DO 40 IEQNS = 1, NEQNS
        IF (IFPRE(IEQNS) .EQ. 1) GO TO 20

C    
C     REDUCE RHS
C
        IF (IEQNS .EQ. NEQNS) GO TO 40
        IEQN1 = IEQNS + 1
    
        DO 10 IROWS = IEQN1, NEQNS
         KOUNT = KOUNT + 1
         FACTR = FRESV(KOUNT)
         IF (FACTR .EQ. 0) GO TO 10
         ASLOD(IROWS)=ASLOD(IROWS)-FACTR*ASLOD(IEQNS)
  10    CONTINUE
        GO TO 40
C    
C     ADJUST RHS TO PRESCRIBED DISPLACEMENTS
C
  20  DO 30 IROWS = IEQNS, NEQNS
      ASLOD(IROWS)=ASLOD(IROWS)-ASTIF(IROWS,IEQNS)*FIXED(IEQNS) 
     *       
  30  CONTINUE
  40  CONTINUE
    
      RETURN
      END
    