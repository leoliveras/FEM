SUBROUTINE INITAL
    USE COMMON
    implicit none
!********************************************************************
!
! *** ALLOCATES AND INITIALIZES TO ZERO ALL ACCUMULATIVE ARRAYS
!
!********************************************************************

    !Fixed value of the displacements
    allocate(FIXED(NSVAB)); FIXED = 0.d0;  

    !Local                                     
    allocate(ESTIF(NEVAB,NEVAB)); ESTIF = 0.d0;

    !Global
    allocate(ASLOD(NSVAB)); ASLOD = 0.d0;            
    allocate(ASTIF(NSVAB,NSVAB)); ASTIF = 0.d0;      
                                       
    !Displacements and forces
    allocate(XDISP(NSVAB)); XDISP = 0.d0;            
    allocate(TDISP(NPOIN,NDOFN)); TDISP = 0.d0;      
    allocate(ELOAD(NELEM,NEVAB)); ELOAD = 0.d0;
    allocate(TLOAD(NELEM,NEVAB)); TLOAD = 0.d0;
    
    !Stress and reactions
    allocate(STRES(NELEM)); STRES=0.d0;     
    allocate(TREAC(NPOIN,NDOFN)); TREAC=0.d0;     

    !Models
    allocate(XAREA(NELEM)); XAREA = 0.d0;
    allocate(YOUNG(NELEM)); YOUNG = 0.d0;
    allocate(ELENG(NELEM)); ELENG = 0.d0;
    allocate(STRAN(NELEM)); STRAN = 0.d0;
    allocate(TSTRN(NELEM)); TSTRN = 0.d0;   
    allocate(VIVEL(NELEM)); VIVEL = 0.d0; 
    
    allocate(PLAST(NELEM)); PLAST = 0.d0; 
    allocate(GAMMA(NELEM)); GAMMA = 0.d0;
    allocate(HARDS(NELEM)); HARDS = 0.d0;
    allocate(YIELD(NELEM)); YIELD = 0.d0;
    
    allocate(FLUEN(NELEM)); FLUEN = 0.d0; 
    allocate(YONG0(NELEM)); YONG0 = 0.d0;
    allocate(YONG1(NELEM)); YONG1 = 0.d0;
    allocate(GAMA1(NELEM)); GAMA1 = 0.d0;
    allocate(HISTY(NELEM)); HISTY = 0.d0;
    allocate(DDASH(NELEM)); DDASH = 0.d0;
    allocate(DASH1(NELEM)); DASH1 = 0.d0;
    allocate(CREPS(NELEM)); CREPS = 0.d0; 
    allocate(SIGM1(NELEM)); SIGM1 = 0.d0;
    allocate(LASTS(NELEM)); LASTS = 0.d0; 
    allocate(LASTF(NELEM)); LASTF = 0.d0;


    !Gauss
    allocate(FRESV(100000)); FRESV = 0.d0
    allocate(REACT(NSVAB)); REACT = 0.d0
    
    !LAPACK
    Allocate(indx(NSVAB)); indx = 0.d0
    Allocate(ipiv(NSVAB)); ipiv = 0
    Allocate(vv(NSVAB)); vv = 0.d0
    Allocate(a1(NSVAB,NSVAB)); a1 = 0.d0
    Allocate(b(NSVAB)); b = 0.d0

    !Incidence index vector
    allocate(ISDOF(NELEM*NNODE)); ISDOF = 0.d0;     
    allocate(FSDOF(NELEM*NNODE)); FSDOF = 0.d0;    
    
    !Rotation
    allocate(CALFA(IELEM)); CALFA = 0.d0
    allocate(SALFA(IELEM)); SALFA = 0.d0
    
    
    !Sparse matrix assembly
    allocate(COEFF(NELEM)); COEFF = 0.d0
    allocate(GADOF(NELEM, NNODE*NDOFN)); GADOF = 0.d0
    allocate(ISPAR(NTERM)); ISPAR = 0.d0
    allocate(JSPAR(NTERM)); JSPAR = 0.d0
    allocate(VSPAR(NTERM)); VSPAR = 0.d0

    RETURN
END SUBROUTINE INITAL