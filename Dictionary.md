# FEM
  All variable names are chosen to be 5 characters in length!

NMATS ---> Number of different MATerialS
PROPS ( ) ---> Array of material PROPertieS
NEVAB ---> Number of Element VAriaBles
NNODE ---> Number of NODes per Elernent
NDOFN ---> Number of Degrees Of Freedorn per Node
  A ‘common root' principle is adopted
  A single variable is employed with different prefixes depending on its
   i)   Prefix I, J or L will be used to indicate a DO loop variable
   ii)  Prefix K will indicate a counter
   iii) Prefix M will indicate a maximurn value
   iv)  Prefix N will indicate a given number
For example: 
IPOIN ---> a particular nodal point
NPOIN ---> number of nodal points in the problem
MPOIN ---> maximum permissible number of nodal points in the program
