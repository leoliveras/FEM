 MODULE STRDFN 
    use COMMON
    implicit none
! ***
!     STRAIN DERIVATIVE FUNCTION
! *** 
    contains
    real (8) function STDIV(STRCH)
        implicit none
        real(8), intent(in) :: STRCH
        STDIV = STRCH
    end function
     
END MODULE STRDFN
