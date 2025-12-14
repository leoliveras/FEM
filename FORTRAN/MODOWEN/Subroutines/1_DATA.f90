SUBROUTINE DATA
    USE COMMON
    Implicit None

!**************************************************************************************************
!Read data file
!**************************************************************************************************

open(1, file="./Example_Cap3.2-8.txt", STATUS="old")


!**************************************************************************************************
!**************   Geometry of the structure and the support conditions   **************************
!**************************************************************************************************

!*** Read and write the control parameters for the problem
    Read(1,*)!***Global parameters:________________________________________________________________
    Read(1,*)!**
    Read(1,*)label,NPOIN
    Read(1,*)label,NELEM
    Read(1,*)label,NBOUN
    Read(1,*)label,NMATS
    Read(1,*)label,NPROP
    Read(1,*)label,NNODE
    Read(1,*)label,NINCS
    Read(1,*)label,NALGO
    Read(1,*)label,NDOFN
    Read(1,*)label,HALGO
    Read(1,*)label,EPATH
    
    MINCS=NINCS

    write(*,'(//,1X,"NPOIN =",I5,3X,"NELEM =",I5,3X,"NBOUN =",I5,3X,&
                    "NMATS =",I5,3X,"NPROP =",I5,3X,"NNODE =",I5,3X,&
                    "NINCS =",I5,3X,"NALGO =",I5,3X,"NDOFN =",I5)') &
                    NPOIN,NELEM,NBOUN,NMATS,NPROP,NNODE,NINCS,NALGO,NDOFN

    NEVAB = NDOFN * NNODE   !Number of element variables
    NSVAB = NDOFN * NPOIN   !Number of structural variables
    NTERM = NELEM * (NNODE*NDOFN)**2
    Read(1,*)!**

!*** Read and write the material properties for each individual material
    Read(1,*)!***Properties_______________________________________________________________________
    Read(1,*)!**Blank
    write(*,'(/,1X,"PROPERTIES")')
    allocate(PROPS(NMATS,NPROP)); PROPS=0.d0
    allocate(LABELS(NMATS,NPROP)); LABELS=""

    do IMATS = 1, NMATS
        
        read(1,*)!**Blank
        read(1,*) (LABELS(IMATS,i), PROPS(IMATS,i), i=1,NPROP)
        

        if(IMATS > 1) write(*,'(/)')!**Blank
        write(*,'(2X,"MATERIAL NUMBER =",I5)') IMATS

        write(*,'(3X,"AREA  = ",F15.5)') PROPS(IMATS,1)
        write(*,'(3X,"YOUNG = ",F15.5)') PROPS(IMATS,2)
        if (NPROP == 2)  exit
        write(*,'(3X,"HARDS = ",F15.5)') PROPS(IMATS,3)   
        write(*,'(3X,"YIELD = ",F15.5)') PROPS(IMATS,4)
        if (NPROP == 4)  exit
        write(*,'(3X,"GAMMA = ",F15.5)') PROPS(IMATS,5)    
        if (NPROP == 5)  exit
        write(*,'(3X,"YONG0 = ",F15.5)') PROPS(IMATS,6)
        write(*,'(3X,"GAMA1 = ",F15.5)') PROPS(IMATS,7)
        write(*,'(3X,"YONG1 = ",F15.5)') PROPS(IMATS,8)

    end do
    Read(1,*)!**Blank

!**************************************************************************************************
!*******************************   Material properties   ******************************************
!**************************************************************************************************
!
!*** Read and write the nodal connection numbers and material identification number of each element
    read(1,*)!***Assembly
    read(1,*)!**
    write(*,'(/8X,"ELEMENT", 5X,"MATERIAL",11X, "NODES")')
    allocate(LNODS(NELEM,NNODE));LNODS=0
    allocate(MATNO(NELEM));MATNO=0
    
    do IELEM = 1, NELEM
        read(1,*) JELEM, MATNO(JELEM), LNODS(JELEM,1:NNODE)
        write(*,*) JELEM, MATNO(JELEM), LNODS(JELEM,1:NNODE)
    end do

    Read(1,*)!**
    write(*,'(/,7X,"NODE",8X,"X",14X,"Y")')
!*** Read and write the coordinate of each nodal point.
    Read(1,*)!**
    allocate(COORD(NPOIN,NDOFN));COORD = 0.d0
    !Read coordinates
    do IPOIN = 1, NPOIN
        read(1,*) JPOIN, (COORD(JPOIN,IDOFN), IDOFN=1,NDOFN)
    end do

    ! Write coordinates
    do IPOIN = 1, NPOIN
        write(*,'(I10,2F15.5)') IPOIN, (COORD(IPOIN,IDOFN), IDOFN=1,NDOFN)
    end do
    Read(1,*)!**


!*** Read and write the node number and prescribed value for each degree of freedom
    Read(1,*)!***Boundary
!*** Initialise the arrays for locating and recording prescribed values of the unknown values of the unknown
!      IFPRE --> indicate that the associated variable is prescribed
!      PEFIX --> Position in PEFIX corresponding to the prescribed value 
    allocate(IFPRE(NSVAB)); IFPRE=0
    allocate(PEFIX(NSVAB)); PEFIX=0.d0

!     for each boundary node and store in the global arrays IFPRE and PEFIX
!     NBOUN --> Total number of boundary points (nodal points at which the value of the unknown is prescribed).
!              (In this context an internal node can be a boundary node).
!     NODFX --> temporary variable that describe any nodal points at which a degree of freedom has a prescribed value
!     IDOFN --> ranges over 1 (ux) to the number of degrees of freedom per node NDOFN (ux,uy,etc).                
!     ICODE --> entries in the array that determine which degrees of freedom are to be prescribed at this node  
!                 ICODE(IDOFN) = 1 -> degree of freedom IDOFN at node NODFX has a prescribed value.    
!                 ICODE(IDOFN) = 0 -> degree of freedom IDOFN at node NODFX is a free variable.         
!     VALUE(IDOFN) value for a prescribed degree of freedom (if ICODE (IDOFN) =0, then VALUE(IDOFN) is ignored)
!    
!     for IBOUN=1, then NODFX(1)=1, ICODE(1)=1, VALUE(1)=0 

    Read(1,*)!**Position_Id, dx1_Id, dx2_Id, dx3_Id, dx1, dx2, dx3
    write(*,'(/)')
    if (NDOFN == 1) then
        write(*,'(1X,"PRES. NODE ",2X,"CODE ",7X,"PRES. X VALUE ")')
    else if (NDOFN ==2) then
        write(*,'(1X,"PRES. NODE ",2X,"CODE ",7X,"PRES. X VALUE ", &
                                   4X,"CODE ",7X,"PRES. Y VALUE ")')
    else if (NDOFN ==3) then
        write(*,'(1X,"PRES. NODE ",2X,"CODE ",7X,"PRES. X VALUE ", &
                                   4X,"CODE ",7X,"PRES. Y VALUE ", &
                                   4X,"CODE ",7X,"PRES. Z VALUE ")')
    end if

    allocate(VALUE(NSVAB));VALUE=0.d0
    allocate(ICODE(NDOFN));ICODE=0
    do IBOUN = 1, NBOUN
        read(1,*) NODFX, ICODE(1:NDOFN), VALUE(1:NDOFN)
        Write(*,'(I10,1X,I5,5X,F15.5,5X,I5,5X,F15.5)') NODFX, ((ICODE(IDOFN), VALUE(IDOFN)),IDOFN=1,NDOFN)
!     In order to simplify the solution process, the information stored in arrays 
!     ICODE and VALUE is transferred to much larger arrays IFPRE (NPOSN) and PEFIX (NPOSN) respectively 
!     NPOSN --> ranges over all the degrees of freedom for the whole finite element mesh
!   
        NPOSN = (NODFX - 1) * NDOFN
    
!     for IODFN=1, then NPOSN=(2-1)*1=1, IFPRE(1)=ICODE(1)=1, PEFIX(1) = VALUE(1)=0
        do IDOFN = 1, NDOFN
            NPOSN = NPOSN + 1
            IFPRE(NPOSN) = ICODE(IDOFN)
            PEFIX(NPOSN) = VALUE(IDOFN)
        end do
    end do

    Read(1,*)!**

!**********************************************************************************************************
!**************************  Frontal method of equation solution   ****************************************
!**********************************************************************************************************
!
!*** Read and write the nodalloads for each element.
!     IELEM --> indicates the element number 
!     IEVAB --> relates to the degrees of freedom of the element --> IEVAB = 1 to NEVAB (number of element variables)
!     RLOAD (IELEM, IEVAB) --> Array that specify the nodal loads acting on the two nodes associated with the element 
!
    Read(1,*)!***Boundary conditions: Nodal load ____________________________________________________________
    Read(1,*)!**
    Read(1,*)label,NLOAD
    Read(1,*)!Load_Id, F_ext1_Id, F_ext2_Id, F_ext3_Id, F_ext1, F_ext2, F_ext3
    allocate(RLOAD(NELEM,NEVAB));RLOAD=0.d0

    write(*,'(/3X,"ELEMENT",14X,"LOAD NODE 1",19X,"LOAD NODE 2")')

    do IELEM = 1, NELEM
        do IEVAB = 1, NEVAB
            RLOAD(IELEM, IEVAB) = 0.0
        end do
    end do
!     for IELEM=1, then JELEM(1)=1, RLOAD(1,1)=0, RLOAD(1,2)=15.0 
    do IELEM=1, NLOAD
        read(1,*) JELEM, RLOAD(JELEM, 1:NEVAB)
    end do

    do IELEM = 1, NELEM
        write(*,'(I10,4F15.5)') IELEM, (RLOAD(IELEM, IEVAB), IEVAB=1,NEVAB)
    end do
    read(1,*)!**

    
!*** Read and write the time parameters (controls the timestepping algorithm).
    read(1,*)!***Time parameters:________________________________________________________________
!   TAUFT --> The parameter (\tau) that limit the viscoplastic strain increment 
!   DTINT --> The time-step length for the first time step
!   FTIME --> The factor k which limits the relative length of successive time steps 
!             (Stability of the solution process is also aided by restricting the length of successive time steps)
!              k ranges 1,5 to 2
    read(1,*)!**
    read(1,*) label,TAUFT
    read(1,*) label,DTINT
    read(1,*) label,FTIME
    write(*,'(/,1X,"TAUFT =",E15.5,/,1X,"DTINT =",E15.5,/,1X,"FTIME =",E15.5)') &
        TAUFT, DTINT, FTIME
    Read(1,*)!**
    

END SUBROUTINE DATA


  
