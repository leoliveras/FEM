
      SUBROUTINE GREDUC
C***********************************************************************
C                     GAUSSIAN REDUCTION ROUTINE
C***********************************************************************

      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,IITER,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NITER,NOUTP,FACTO,PVALU
               
      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4)
 
C   
C         GAUSSIAN REDUCTION ROUTINE
C
          KOUNT = 0
          NEQNS = NSVAB
    
      DO 70 IEQNS = 1, NEQNS
             IF (IFPRE(IEQNS) .EQ. 1) GO TO 40
C    
C         REDUCE EQUATIONS
C
             PIVOT = ASTIF(IEQNS, IEQNS)
             IF (ABS(PIVOT) .LT. 1.0E-10) GO TO 60
             IF (IEQNS .EQ. NEQNS) GO TO 70
             IEQN1 = IEQNS + 1
             DO 30 IROWS = IEQN1, NEQNS
                KOUNT = KOUNT + 1
                FACTR = ASTIF(IROWS, IEQNS) / PIVOT
                FRESV(KOUNT) = FACTR
                IF (FACTR .EQ. 0.0) GO TO 30
                 DO 10 ICOLS = IEQNS, NEQNS
      ASTIF(IROWS, ICOLS)=ASTIF(IROWS, ICOLS)-FACTR*ASTIF(IEQNS,ICOLS)
     *            
   10            CONTINUE
                ASLOD(IROWS) = ASLOD(IROWS) - FACTR * ASLOD(IEQNS)
   30        CONTINUE
             GO TO 70
C    
C        ADJUST RHS (LOADS) FOR PRESCRIBED DISPLACEMENTS
C
   40    DO 50 IROWS = IEQNS, NEQNS
      ASLOD(IROWS)=ASLOD(IROWS)-ASTIF(IROWS,IEQNS)*FIXED(IEQNS)
     *        
   50    CONTINUE
             GO TO 70
    
   60    WRITE(6,900)
  900    FORMAT(5X, '!! INCORRECT PIVOT')
             STOP
    
   70 CONTINUE
          RETURN
          END