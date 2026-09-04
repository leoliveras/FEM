MODULE STRNFN 
    use COMMON
    implicit none
! ***
!     STRAIN FUNCTION
! *** 
    contains
    real (8) function STNFN(STRCH)
        implicit none
        real(8), intent(in) :: STRCH
        STNFN = 0.5*(STRCH*STRCH - 1.0)
    end function
     
END MODULE STRNFN
