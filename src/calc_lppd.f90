subroutine calc_lppd(x, y, lppd)
  implicit none 
  real(8), intent(in) :: x, y
  real(8), intent(out) :: lppd
  real(8) :: c
  real(8) :: r
  

  ! PPD = exp(-r^2) * (cos^2(12*r)+0.01)^10 * Const.
  
  r = sqrt(x*x + y*y)
  c = cos(12.d0 * r)
  lppd = -r*r + 10.d0 * log(c * c  + 0.01d0)
  
  return 
end subroutine calc_lppd
