PROGRAM MASTER
    use COMMON
    implicit none

!***********************************************************************
! *** PROGRAM FOR THE TRUSS SOLUTION OF NONLINEAR PROBLEMS
!***********************************************************************

    ! --- START OF TIME MEASUREMENT ---
    call system_clock(CLOK1, RATE1)
    ! ---------------------------------

    TTIME = 0.0d0

    call DATA
    call INITAL

    do IINCS = 1, MINCS
        call INCLOD
        DTIME = 0.0d0

        do ISTEP = 1, NSTEP
            TTIME = TTIME + DTIME
            call NONAL
            if (KRESL == 1) call STIFF
            call ASSEMB
            
            !For lapack resolution
            !call DGESV( NSVAB, 1, ASTIF, NSVAB, ipiv, ASLOD, NSVAB, info )
            !call LAPACK
            
            !For gauss elimination resolution
            if (KRESL == 1) call GREDUC
            if (KRESL == 2) call RESOLV
            call BAKSUB
            
            call INCVEP
            call CONVEP

            if (NCHEK == 0) then
                call RESULT
                exit
            end if

            if (ISTEP == 1 .and. NOUTP == 1) call RESULT
            if (NOUTP == 2) call RESULT
        end do

        if (NCHEK /= 0) then
            write(*,'(//5X,"STEADY STATE NOT ACHIEVED")')
            stop
        end if
    end do

    ! --- END OF TIME MEASUREMENT ---
    call system_clock(CLOK2)
    ELAPSE = real(CLOK2 - CLOK1, 8) / real(RATE1, 8)
    print *, "CPU TIME (s) = ", ELAPSE
    ! ---------------------------------

    stop
END PROGRAM MASTER
