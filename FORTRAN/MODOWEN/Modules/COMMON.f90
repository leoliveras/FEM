 MODULE COMMON
    implicit None
!***Common block variables
!**************************************************************************************************
!***Control parameters for the problem
!**************************************************************************************************
        integer(4)::NPOIN=0              
        integer(4)::NELEM=0                
        integer(4)::NBOUN=0                 
        integer(4)::NMATS=0                
        integer(4)::NPROP=0                 
        integer(4)::NNODE=0                 
        integer(4)::NINCS=0                
        integer(4)::NALGO=0                 
        integer(4)::NDOFN=0  
        integer(4)::HALGO=0

!**************************************************************************************************
!***DATA
!**************************************************************************************************

        integer(4)::NEVAB=0                 
        integer(4)::NSVAB=0                 
        integer(4)::JMATS=0                
        real,Allocatable::PROPS(:,:)
                                            
        real(8),allocatable::XAREA(:)           
        real(8),allocatable::YOUNG(:)     
        integer(4)::JELEM=0            
        integer,Allocatable::MATNO(:)      
        integer,Allocatable::LNODS(:,:)  
        real(8),Allocatable::COORD(:,:)  
        integer(4)::JPOIN=0              

        integer(4)::NDOFX=0                
        integer(4),Allocatable::IFPRE(:) 
        integer(4),Allocatable::ICODE(:) 
        real(8),Allocatable::PEFIX(:)  
        real(8),Allocatable::VALUE(:)   
        integer(4)::NPOSN=0                 

        integer(4)::NLOAD=0       
        integer(4)::PLOAD=0                
        real(8),Allocatable::RLOAD(:,:)             
        
        real(8)::TAUFT=0.d0     
        real(8)::DTINT=0.d0
        real(8)::FTIME=0.d0
                                            
        integer(4)::NITER=0                
        real(8)::TOLER=0.d0                

!**************************************************************************************************
!***INITIALIZATION
!**************************************************************************************************

        real(8),Allocatable::ESTIF(:,:)  
        real(8),Allocatable::ASTIF(:,:)   
        real(8),Allocatable::COEFF(:);
        real(8),Allocatable::teste(:,:)
        real(8)::FMULT=0.d0
                                            
        real(8),Allocatable::ELENG(:)         
        real(8),Allocatable::STRAN(:)
        real(8),Allocatable::TSRAN(:)
        real(8),Allocatable::TSTRN(:)
        real(8),allocatable::ELOAD(:,:)  
        real(8),Allocatable::TLOAD(:,:)  
        real(8),allocatable::ASLOD(:)   
                                        
        real(8),Allocatable::TDISP(:,:)
        real(8),Allocatable::XDISP(:)     
                                        
        real(8),Allocatable::STRES(:) 
        real(8),Allocatable::TREAC(:,:)
        


!**************************************************************************************************
!***NONAL AND NLF
!**************************************************************************************************

        real(8)::FACTO=0.d0          
        integer(4)::KRESL=0
        integer(4)::HRESL=0
        real(8),Allocatable::FIXED(:)
        
        


!**************************************************************************************************
!***MONITORS AND CONVERGENCE
!**************************************************************************************************

        integer(4)::NOUTP=0
        integer(4)::IITER=0               
        integer(4)::NCHEK=0      
        real(8)::TOTAL=0.d0
        real(8)::FIRST=0.d0        
        real(8)::RINTL=0.d0               
        real(8)::RCURR=0.d0               
        real(8)::PVALU=0.d0                
        real(8)::RATIO=0.d0                           
                                            
                                        
!**************************************************************************************************
!***GAUSS REDUCTION AND BACKSUBST. SOLUTION
!**************************************************************************************************
        real(8)::PIVOT=0.d0
        real(8)::FACTR=0.d0
        real(8),allocatable::FRESV(:)
        integer(4)::KOUNT,IEQN1,NEQN1,NBACK,NBAC1
        real(8),allocatable::REACT(:)
        real(8)::RESID=0.d0

        

!**************************************************************************************************
!***MODEL PROPERTIES
!**************************************************************************************************
        !Rotation
        real(8)::XPOT1,XPOT2,YPOT1,YPOT2,DELTX,DELTY,DISP1,DISP2,DSPGX,DSPGY
        
        real(8),allocatable::CALFA(:)
        real(8),allocatable::SALFA(:)

        integer(4)::LPROP

        ! Time parameters
        real(8)::DNEXT,DTIME,DELTA,EDISP,SNTOT,DELTM,DELTN,DELTD,TTIME
        real(8),allocatable::VIVEL(:)

        !Viscoplastic
        real(8),Allocatable::PLAST(:)
        real(8),allocatable::GAMMA(:)
        real(8),allocatable::HARDS(:) 
        real(8),allocatable::YIELD(:) 
        real(8)::PREYS = 0.d0  
        
        !Viscoelastic
        real(8),Allocatable::FLUEN(:) 
        real(8),allocatable::YONG0(:)   
        real(8),allocatable::YONG1(:)  
        real(8),allocatable::GAMA1(:) 
        real(8),allocatable::HISTY(:) 
        real(8),allocatable::DASH1(:) 
        real(8),allocatable::DDASH(:) 
        real(8),allocatable::SIGM1(:) 
        real(8)::TAUVE = 0.d0
        real(8)::IXCSI = 0.d0
        real(8),allocatable::LASTS(:)
        real(8),allocatable::LASTF(:)
        real(8),allocatable::CREPS(:)
    
        
        

!**************************************************************************************************
!***LAPACK
!**************************************************************************************************

        integer(4),Allocatable::ipiv(:)
        integer(4)::info
        integer(4),Allocatable::idx1(:,:)
        integer(4),Allocatable::idx2(:,:)     

        
        integer(4)::IMAX,NMAX, np, n ,i, ii, j, k, ll
        real(8)::det,d,aamax,dum,TINY,sumv
        
        integer(4),Allocatable::indx(:)
        real(8),allocatable::vv(:)
        real(8), allocatable :: a1(:,:)
        real(8),Allocatable::b(:)


!**************************************************************************************************
!***TEMPORY VARIABLES
!**************************************************************************************************

        integer(4)::IMATS,IPROP,INODE,IELEM,ISVAB,IEVAB,IBOUN,IDOFN,ILOAD,ISTEP,IPOIN,IINCS,ITERM,&
                    IEQNS,IROWS,ICOLS,&
                    NROWS,NROWE,NCOLS,NCOLE,NTERM,NEQNS,NLOCA,NSTEP,&
                    JNODE,JDOFN,&
                    NODE1,NODE2,NODEI,NODEJ,NODFX,XPOIN,YPOIN,INDEX,FSVAB
        
        character(20) :: label
        character(10),allocatable :: LABELS(:,:) 
        
        integer,allocatable::ISDOF(:)
        integer,allocatable::FSDOF(:)
        integer,allocatable::GADOF(:,:)
        integer,allocatable::LOFST(:)
        integer,allocatable::ISPAR(:)
        integer,allocatable::JSPAR(:)
        real(8),allocatable::VSPAR(:)
        integer,allocatable::GAPRE(:)
        
        

END MODULE COMMON