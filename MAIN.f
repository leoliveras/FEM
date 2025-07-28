      PROGRAM MASTER UNVISC
C***********************************************************************
C
C *** PROGRAM FOR THE 1-D SOLUTION OF NONLINEAR PROBLEMS
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
    

      TTIME=0.0

      CALL DATA
      CALL INITAL
      CALL STUNVP

      DO 30 IINCS=1,NINCS
         CALL INCLOD
         DTIME=0.0
         DO 10 ISTEP=1,NSTEP
            TTIME=TTIME+DTIME
            CALL NONAL
            CALL ASSEMB
            IF(KRESL.EQ.1) CALL GREDUC
            IF(KRESL.EQ.2) CALL RESOLV
            CALL BAKSUB
            CALL INCVP
            CALL CONVP
            IF(NCHEK.EQ.0) GO TO 20
            IF(ISTEP.EQ.1.AND.NOUTP.EQ.1) CALL RESULT
            IF(NOUTP.EQ.2) CALL RESULT
 10      CONTINUE
         WRITE(6,900)
900      FORMAT(1H0,5X,'STEADY STATE NOT ACHIEVED')
         STOP
 20      CALL RESULT
 30   CONTINUE
      STOP
      END
