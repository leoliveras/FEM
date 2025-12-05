PROGRAM MASTER 
    use COMMON
    implicit none
!***********************************************************************
! *** PROGRAM FOR TRUSS SOLUTION OF NONLINEAR PROBLEMS
!***********************************************************************


   TTIME = 0.0d0

  ! open(unit=10, file="Ex_Cap4-2.txt", status="old")
   call DATA
   call INITAL

   do IINCS = 1, NINCS
        call INCLOD
        DTIME = 0.0d0

        do ISTEP = 1, NSTEP
            TTIME = TTIME + DTIME
            call NONAL
            if (KRESL == 1) call STIFF
            call ASSEMB
            if (KRESL == 1) call GREDUC
            if (KRESL == 2) call RESOLV
            call BAKSUB
            call INCVEP
            call CONVP

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
    stop
END PROGRAM MASTER

     