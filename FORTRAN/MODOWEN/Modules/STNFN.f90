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
        STNFN = STRCH - 1.d0
    end function
     
END MODULE STRNFN
