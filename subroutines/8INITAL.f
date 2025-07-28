      SUBROUTINE INITAL
C********************************************************************
C
C *** INITIALIZES TO ZERO ALL ACCUMULATIVE ARRAYS
C
C********************************************************************

      COMMON/UNIM1/NPOIN,NELEM,NBOUN,NLOAD,NPROP,NNODE,IINCS,IITER,
     *             KRESL,NCHEK,TOLER,NALGO,NSVAB,NDOFN,NINCS,NEVAB,
     *             NITER,NOUTP,FACTO,PVALU
     
      COMMON/UNIM2/PROPS(5,5),COORD(26),LNODS(25,2),IFPRE(52),
     *             FIXED(52),TLOAD(25,4),RLOAD(25,4),ELOAD(25,4),
     *             MATNO(25),STRES(25,2),PLAST(25),XDISP(52),
     *             TDISP(26,2),TREAC(26,2),ASTIF(52,52),ASLOD(52),
     *             REACT(52),FRESV(1352),PEFIX(52),ESTIF(4,4)

      DO 20 IELEM=1,NELEM
       PLAST(IELEM)=0.0
      DO 10 IDOFN=1,NDOFN
  10  STRES(IELEM,IDOFN)=0.0

      DO 20 IEVAB=1,NEVAB
       ELOAD(IELEM,IEVAB)=0.0
  20  TLOAD(IELEM,IEVAB)=0.0

      DO 30 IPOIN=1,NPOIN
      DO 30 IDOFN=1,NDOFN
       TDISP(IPOIN,IDOFN)=0.0
  30  TREAC(IPOIN,IDOFN)=0.0

      RETURN
      END
