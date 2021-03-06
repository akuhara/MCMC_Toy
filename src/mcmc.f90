subroutine mcmc(x, y, t, lppd)
  use params
  implicit none 
  real(8), intent(inout) :: x, y, lppd
  real(8), intent(in) :: t
  real(8) :: xp, yp, qrat, lppdp
  logical :: null, accept

  null = .false.
  accept = .false.

  ! Propose model
  call prop_model(x, y, xp, yp, qrat)
  if (xp < x_min .or. xp > x_max .or. &
       & yp < y_min .or. yp > y_max) then
     null = .true.
  end if
  
  !write(*,*)"Current:", x, y
  !write(*,*)"Proposed:", xp, yp
  
  if (.not. null) then
     call calc_lppd(xp, yp, lppdp)
     !write(*,*)"logPPD:", lppd, "->", lppdp
     
     call judge(lppd, lppdp, qrat, t, accept)
     !write(*,*)"Accept?", accept
     
     if (accept) then
        x = xp
        y = yp
        lppd = lppdp
     end if
  end if
  
  return 
end subroutine mcmc




