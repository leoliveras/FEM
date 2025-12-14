SUBROUTINE CONUND
    use COMMON
    implicit none
    
    NCHEK = 0
    RESID = 0.d0
    RETOT = 0.d0
    STFOR = 0.d0
    TOFOR = 0.d0
    
    do IELEM=1,NELEM
        IEVAB=0
        do INODE=1,NNODE
            NODNO=LNODS(IELEM,INODE)
            do IDOFN=1,NDOFN
               IEVAB=IEVAB+1
               NPOSN=(NODNO-1)*NDOFN+IDOFN
               STFOR(NPOSN)=STFOR(NPOSN)+ELOAD(IELEM,IEVAB)
               TOFOR(NPOSN)=TOFOR(NPOSN)+TLOAD(IELEM,IEVAB)
            end do 
        end do
    end do

    
    do ISVAB=1,NSVAB
         REFOR=TOFOR(ISVAB)-STFOR(ISVAB)
         RESID=RESID+REFOR*REFOR
         RETOT=RETOT+TOFOR(ISVAB)*TOFOR(ISVAB)
    end do
    
    ELOAD=TLOAD-ELOAD
    
    RATIO=100.d0*SQRT(RESID/RETOT)
    if(RATIO >= TOLER) NCHEK=1
    if(ISTEP /= 1) then
      if(RATIO >= PVALU) NCHEK=999
    end if  
    if(ISTEP == 1) PVALU=RATIO
    write(*,'(5X,"ITERATION NUMBER",I5,3X,"CONVERGENCE CODE",I4,3X,"NORM OF RESIDUAL SUM RATIO",E14.6)') ISTEP,NCHEK,RATIO

END SUBROUTINE CONUND