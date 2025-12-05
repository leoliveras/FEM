MODULE ASPARSE
contains
    function sparse(ISPAR, JSPAR, VSPAR, NTERM, NSVAB) result(H)
        implicit none
        integer, intent(in) :: ISPAR(:), JSPAR(:), NTERM, NSVAB
        real(8), intent(in) :: VSPAR(:)
        real(8) :: H(NSVAB, NSVAB)
        real(8) :: HLOCA(NSVAB, NSVAB)
        integer :: ITERM
        H = 0.0d0
!$omp parallel private(Hlocal, ITERM) shared(H)
        HLOCA = 0.0d0
!$omp do
        do ITERM = 1, NTERM
            HLOCA(ISPAR(ITERM), JSPAR(ITERM)) = HLOCA(ISPAR(ITERM), JSPAR(ITERM)) + VSPAR(ITERM)
        end do
!$omp end do
!$omp critical
        H = H + HLOCA
!$omp end critical
!$omp end parallel
    end function sparse
END MODULE ASPARSE