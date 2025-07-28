      SUBROUTINE INCVP
C***********************************************************************
C
C *** CALCULATES INTERNAL EQUIVALENT NODAL FORCES
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

C     
C --- ZEROS ELOAD 
C

      DO 10 IELEM = 1, NELEM
      DO 10 IEVAB = 1, NEVAB
   10 ELOAD(IELEM,IEVAB) = 0.0

      DNEXT = FTIME * DTIME

C
C --- LOOP OF THE ELEMENTS
C

      DO 30 IELEM = 1, NELEM
          LPROP = MATNO(IELEM)
          YOUNG = PROPS(LPROP,1)
          XAREA = PROPS(LPROP,2)
          YIELD = PROPS(LPROP,3)
          HARDS = PROPS(LPROP,4)
          GAMMA = PROPS(LPROP,5)
          NODE1 = LNODS(IELEM,1)
          NODE2 = LNODS(IELEM,2)
          ELENG = ABS(COORD(NODE1) - COORD(NODE2))

          IF (COORD(NODE2) .GT. COORD(NODE1)) 
     *        STRAN = (XDISP(NODE2) - XDISP(NODE1)) / ELENG
          
          IF (COORD(NODE2) .LT. COORD(NODE1))
     *        STRAN = (XDISP(NODE1) - XDISP(NODE2)) / ELENG
              
          STRES(IELEM,1) = STRES(IELEM,1) +
     *         (STRAN - VIVEL(IELEM) * DTIME) * YOUNG
          PLAST(IELEM) = PLAST(IELEM) + VIVEL(IELEM) * DTIME
    
          IF(STRES(IELEM,1) .LT. 0.0) YIELD = -YIELD
          PREYS = YIELD + HARDS * PLAST(IELEM)
    
          IF(ABS(STRES(IELEM,1)) .LE. ABS(PREYS)) GO TO 20
    
          VIVEL(IELEM) = GAMMA * 
     *         (STRES(IELEM,1) - (YIELD + HARDS * PLAST(IELEM)))
          SNTOT = (TDISP(NODE2,1) - TDISP(NODE1,1)) / ELENG
          DELTM = TAUFT * ABS(SNTOT / VIVEL(IELEM))
          IF(DELTM .LT. DNEXT) DNEXT = DELTM
          GO TO 30

   20     VIVEL(IELEM) = 0.0
    
   30 CONTINUE

      DTIME = DNEXT
      IF(ISTEP .EQ. 1) DTIME = DTINT

C    
C --- CÁLCULO DAS FORÇAS INTERNAS
C

      DO 50 IELEM = 1, NELEM
          LPROP = MATNO(IELEM)
          YOUNG = PROPS(LPROP,1)
          XAREA = PROPS(LPROP,2)
          FACTR = (YOUNG * VIVEL(IELEM) * 
     *             DTIME - STRES(IELEM,1)) * XAREA
    
      IF(COORD(NODE2) .GT. COORD(NODE1)) GO TO 40
          ELOAD(IELEM,1) =  FACTR
          ELOAD(IELEM,2) = -FACTR
       GO TO 50

   40 ELOAD(IELEM,1) = -FACTR
      ELOAD(IELEM,2) =  FACTR
   50 CONTINUE

C
C --- SOMA COM TLOAD
C
      DO 60 IELEM = 1, NELEM    
      DO 60 IEVAB = 1, NEVAB
   60 ELOAD(IELEM,IEVAB)=ELOAD(IELEM,IEVAB)+TLOAD(IELEM,IEVAB)
   
      RETURN
      END