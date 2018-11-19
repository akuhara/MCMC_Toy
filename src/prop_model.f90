subroutine prop_model(x, y, xp, yp, qrat)
  use params
  use mt19937
  implicit none 
  real(8), intent(in) :: x, y
  real(8), intent(out) :: xp, yp, qrat
  integer :: itype
  
  itype = int(grnd() * 2)

  if (itype == 0) then
     ! Walk along X axis
     xp = x + (grnd() * 2.d0 - 1.d0) * dx
     yp = y
  else
     ! Walk along Y axis
     xp = x
     yp = y + (grnd() * 2.d0 - 1.d0) * dy
  end if
  
  qrat = 1.d0 
  

  return
end subroutine prop_model
