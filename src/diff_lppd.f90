subroutine diff_lppd(x, y, dlp)
  implicit none 
  real(8), intent(in) :: x, y
  real(8), intent(out) :: dlp(2)
  real(8) :: drdx, drdy, r, c, s, dlpdr


  r = sqrt(x*x + y*y)
  c = cos(24.d0 * r)
  s = sin(24.d0 * r)


  drdx = x / r
  drdy = y / r
  dlpdr = -2.0d0 * (1.02d0 * r + 120.d0 * s  + r * c) / &
       & (c + 1.02d0)
  
  dlp(1) = dlpdr * drdx
  dlp(2) = dlpdr * drdy

  
  return 
end subroutine diff_lppd
  
