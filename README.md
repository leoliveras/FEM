# FEM

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

C All variable names are chosen to be 5 characters in length!

C
C NMATS ---> Number of different MATerialS

C PROPS ( ) ---> Array of material PROPertieS

C NEVAB ---> Number of Element VAriaBles

C NNODE ---> Number of NODes per Elernent

C NDOFN ---> Number of Degrees Of Freedorn per Node

C A ‘common root' principle is adopted

C A single variable is employed with different prefixes depending on its

C   i)   Prefix I, J or L will be used to indicate a DO loop variable

C   ii)  Prefix K will indicate a counter

C   iii) Prefix M will indicate a maximurn value

C   iv)  Prefix N will indicate a given number

C   For example:

C IPOIN ---> a particular nodal point

C NPOIN ---> number of nodal points in the problem

C MPOIN ---> maximum permissible number of nodal points in the program
