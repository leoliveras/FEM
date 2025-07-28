      SUBROUTINE DATA
C***********************************************************************
C     INPUTS DATA DEFINING GEOMETRY, LOADING, BOUNDARY CONDITIONS...ETC.
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
     
      DIMENSION ICODE(2), VALUE(2), TITLE(18)

C
C*** Read and write the problem title
C
      READ(5,975) TITLE
      WRITE(6,975) TITLE
  975 FORMAT(18A4)

!************************************************************************************************************
!**************   Geometry of the structure and the support conditions   ************************************
!************************************************************************************************************

C
C*** Read and write the control parameters for the problem
C     NPOIN --> Total number of nodal points in the structure.
C     IPOIN --> Total number of nodal points in the structure.
C     NELEM --> Total number of elements in the structure.
C     NBOUN --> Total number of boundary points, i.e. nodal points at which the value of the unknown
C               is prescribed. In this context an internal node can be a boundary node.
C     NMATS --> Total number of different materials in the structure.
C     NPROP --> The number of material parameters required to define the characteristics of a material completely:
C                 4-For elasto-plastic problems,
C                 2-For all other applications.
C     NNODE --> Number of nodes per element. For linear displacement onedimensional elements this equals 2.
C     NINCS --> The number of increments in which the total loading is to be applied.
C     NALGO --> Indicator used to identify the type of solution algorithm to be employed:
C     NDOFN --> The number of degrees of freedom per nodal point:
C                 l-For uniaxial problems.
C                 2-For beam bending problems (not consider in chapter 3).
      READ(5,900) NPOIN,NELEM,NBOUN,NMATS,NPROP,NNODE,NINCS,NALGO,NDOFN
  900 FORMAT(9I5)
      WRITE(6,905) NPOIN,NELEM,NBOUN,NMATS,NPROP,NNODE,NINCS,NALGO,NDOFN
  905 FORMAT(//,1X,'NPOIN =', I5,3X, 'NELEM =', I5,3X, 'NBOUN =',I5,3X,
     *             'NMATS =', I5,3X, 'NPROP =', I5,3X, 'NNODE =',I5,3X,
     *             'NINCS =', I5,3X, 'NALGO =', I5,3X, 'NDOFN =',I5)



C 
C     INODE --> ranges from 1 to NNODE (number of nodes)
C     IEVAB --> degrees of freedom of the element ranges from 1 to NEVAB
C     NEVAB --> number of element variables, 1D --> NEVAB=2
C     NDOFN --> number of degrees of freedom per node (1D --> NDOFN=1)
C     NSVAB --> total number of variables in the structure
      NEVAB = NDOFN * NNODE
      NSVAB = NDOFN * NPOIN



C
C*** Read and write the material properties for each individual material
C     IPROP --> the individual property (IPROP=4 --> reference the linear strain hardening parameter H',
C                                        for the material, ***consult appendice for more information)
C     NMATS --> Total number of different materials in the structure.
C     NPROP --> The number of material parameters required to define the characteristics of a material completely
C          *******
C
C     Using Direct method:
C     for IMATS=1, then JMATS(1)=1 (fist material element), IPROP(1)= 10000.0
C
      WRITE(6,910)
  910 FORMAT(1H0,5X,'MATERIAL PROPERTIES')

      DO 10 IMATS = 1, NMATS
         READ(5,915) JMATS, (PROPS(JMATS,IPROP), IPROP = 1, NPROP)
   10    WRITE(6,915) JMATS, (PROPS(JMATS,IPROP), IPROP = 1, NPROP)
  915    FORMAT(I5, 5F15.5)


C************************************************************************************************************
C*******************************   Material properties   ****************************************************
C************************************************************************************************************
C
C*** Read and write the nodal connection numbers and material identification number of each element
C     IPOIN --> corresponds to the number of the nodal point
C     LNODS(NUMEL,INODE) --> the element topology is read into this array
C     NUMEL --> corresponds to the number of the element under consideration 
C     INODE --> ranges from 1 to NNODE
C     MATNO --> each element may has different material properties,
C               so that NUMEL has material properties of type MATNO(NUMEL).
C
C     for IELEM=1, then JELEM(1)=1, LNODS=(1,1)=1, LNODS=(1,2)=2 and MATNO(1)=1
C
      WRITE(6,920)
  920 FORMAT(1H0, 3X, 'EL NODES MAT.')

      DO 20 IELEM = 1, NELEM
      READ(5,925) JELEM,(LNODS(JELEM,INODE),INODE=1,NNODE),MATNO(JELEM)
   20 WRITE(6,925) JELEM,(LNODS(JELEM,INODE),INODE=1,NNODE),MATNO(JELEM)
  925 FORMAT(4I5)

C
C*** Read and write the coordinate of each nodal point.
C     for IPOIN=1, then JPOIN(1)=1, COORD(1)=0
C
      WRITE(6,930)
  930 FORMAT(1H0, 3X, 'NODE', 5X, 'COORD.')

      DO 30 IPOIN = 1, NPOIN
         READ(5,935) JPOIN, COORD(JPOIN)
   30    WRITE(6,935) JPOIN, COORD(JPOIN)
  935    FORMAT(I10, 2F15.5)



C 
C*** Initialise the arrays for locating and recording prescribed values of the unknown values of the unknown
C      IFPRE --> indicate that the associated variable is prescribed
C      PEFIX --> Position in PEFIX corresponding to the prescribed value 
      DO 40 ISVAB = 1, NSVAB
         IFPRE(ISVAB) = 0
   40    PEFIX(ISVAB) = 0.0



C
C*** Read and write the node number and prescribed value for each degree of freedom
C     for each boundary node and store in the global arrays IFPRE and PEFIX
C     NBOUN --> Total number of boundary points (nodal points at which the value of the unknown is prescribed).
C              (In this context an internal node can be a boundary node).
C     NODFX --> temporary variable that describe any nodal points at which a degree of freedom has a prescribed value
C     IDOFN --> ranges over 1 (ux) to the number of degrees of freedom per node NDOFN (ux,uy,etc).                
C     ICODE --> entries in the array that determine which degrees of freedom are to be prescribed at this node  
C                 ICODE(IDOFN) = 1 -> degree of freedom IDOFN at node NODFX has a prescribed value.    
C                 ICODE(IDOFN) = 0 -> degree of freedom IDOFN at node NODFX is a free variable.         
C     VALUE(IDOFN) value for a prescribed degree of freedom (if ICODE (IDOFN) =0, then VALUE(IDOFN) is ignored)
C    
C     for IBOUN=1, then NODFX(1)=1, ICODE(1)=1, VALUE(1)=0 

      IF(NDOFN.EQ.1) WRITE(6,940)
  940 FORMAT(1H0, 1X, 'RES. NODE', 2X, 'CODE', 3X, 'PRES. VALUES')
      IF(NDOFN.EQ.2) WRITE(6,945)
  945 FORMAT(1H0, 1X, 'RES. NODE', 2X, 'CODE', 3X, 'PRES. VALUES', 2X,
     *       'CODE', 3X, 'PRES. VALUES')

      DO 50 IBOUN = 1, NBOUN
         READ(5,950) NODFX,(ICODE(IDOFN),VALUE(IDOFN),IDOFN=1,NDOFN)
         WRITE(6,950) NODFX,(ICODE(IDOFN),VALUE(IDOFN),IDOFN=1,NDOFN)
  950    FORMAT(I10, 2(I5, F15.5))
C     In order to simplify the solution process, the information stored in arrays 
C     ICODE and VALUE is transferred to much larger arrays IFPRE (NPOSN) and PEFIX (NPOSN) respectively 
C     NPOSN --> ranges over all the degrees of freedom for the whole finite element mesh
C               
         NPOSN = (NODFX - 1) * NDOFN
C     for IODFN=1, then NPOSN=(2-1)*1=1, IFPRE(1)=ICODE(1)=1, PEFIX(1) = VALUE(1)=0
         DO 50 IDOFN = 1, NDOFN
            NPOSN = NPOSN + 1
            IFPRE(NPOSN) = ICODE(IDOFN)
   50    PEFIX(NPOSN) = VALUE(IDOFN)




C************************************************************************************************************
C**************************  Frontal method of equαtion solution   ******************************************
C************************************************************************************************************
C
C*** Read and write the nodalloads for each element.
C     IELEM --> indicates the element number 
C     IEVAB --> relates to the degrees of freedom of the element --> IEVAB = 1 to NEVAB (number of element variables)
C     RLOAD (IELEM, IEVAB) --> Array that specify the nodal loads acting on the two nodes associated with the element 
C
      WRITE(6,955)
  955 FORMAT(1H0, 2X, 'ELEMENT', 10X, 'NODAL LOADS')

      DO 60 IELEM = 1,NELEM
      DO 60 IEVAB = 1,NEVAB
   60 RLOAD(IELEM,IEVAB) = 0.0

C     for IELEM=1, then JELEM(1)=1, RLOAD(1,1)=0, RLOAD(1,2)=15.0 
   70 READ(5,960) JELEM,(RLOAD(JELEM,IEVAB),IEVAB=1,NEVAB)
         IF(JELEM.NE.NELEM) GO TO 70
         DO 80 IELEM=1, NELEM 
   80     WRITE(6,960) IELEM,(RLOAD(IELEM,IEVAB),IEVAB=1,NEVAB)
  960     FORMAT(I10,5F15.5)


C*** Read and write the time parameters (controls the timestepping algorithm).
C   TAUFT --> The parameter (\tau) that limit the viscoplastic strain increment 
C   DTINT --> The time-step length for the first time step
C   FTIME --> The factor k which limits the relative length of successive time steps 
C             (Stability of the solution process is also aided by restricting the length of successive time steps)
C              k ranges 1,5 to 2
      READ(5,965) TAUFT, DTINT, FTIME
  965 FORMAT(3F15.5)
      WRITE(6,970) TAUFT, DTINT, FTIME
  970 FORMAT(//,1X,'TAUFT =',E15.5,3X,'DTINT =',E15.5,3X,
     *             'FTIME =',E15.5)


      RETURN
      END