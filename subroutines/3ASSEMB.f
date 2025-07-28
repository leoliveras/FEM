      SUBROUTINE ASSEMB
C************************************************************************
C***                   ELEMENT ASSEMBLY ROUTINE                         *
C************************************************************************

      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,IITER,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NITER,NOUTP,FACTO,PVALU

      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4)
C
C       ELEMENT ASSEMBLY ROUTINE     
C 
        REWIND 1

        DO 10 ISVAB = 1, NSVAB
 10     ASLOD(ISVAB)=0.0

        IF (KRESL .EQ. 2) GO TO 30

        DO 20 ISVAB = 1, NSVAB
        DO 20 JSVAB = 1, NSVAB
 20     ASTIF(ISVAB, JSVAB) = 0.0
 30     CONTINUE

C     ASSEMBLE THE ELEMENT LOADS

      DO 50 IELEM = 1, NELEM
      READ(1) ESTIF

      DO 40 INODE = 1, NNODE
         NODEI = LNODS(IELEM, INODE)
      DO 40 IDOFN = 1, NDOFN
         NROWS = (NODEI - 1) * NDOFN + IDOFN
         NROWE = (INODE - 1) * NDOFN + IDOFN
         ASLOD(NROWS) = ASLOD(NROWS) + ELOAD(IELEM, NROWE)

C     ASSEMBLE THE ELEMENT STIFFNESS MATRICES

      IF (KRESL .EQ. 2) GO TO 40

      DO 40 JNODE = 1, NNODE
         NODEJ = LNODS(IELEM, JNODE)
         DO 40 JDOFN = 1, NDOFN
             NCOLS = (NODEJ - 1) * NDOFN + JDOFN
             NCOLE = (JNODE - 1) * NDOFN + JDOFN
             ASTIF(NROWS, NCOLS) = ASTIF(NROWS, NCOLS) +
     *                             ESTIF(NROWE, NCOLE)
 40     CONTINUE
 50     CONTINUE

        RETURN
        END