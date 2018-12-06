subroutine hmc(x, y, lppd)
  use mt19937
  use params
  implicit none 
  real(8), intent(inout) :: x, y, lppd
  real(8) :: u, u0, k, k0, x0, y0
  real(8) :: p(2), p0(2), dudq(2), q(2), q0(2), dlp(2)
  real(8) :: pp(2), qq(2), qmin(2), qmax(2)
  real(8), external :: gauss
  integer :: i, j



  ! Set Initial momentum
  p(1) = gauss()
  p(2) = gauss()
  p0(1) = p(1)
  p0(2) = p(2)

  qmin(1) = x_min
  qmin(2) = y_min
  qmax(1) = x_max
  qmax(2) = y_max
  
  !write(*,*)p(1), p(2), "AAA"
  k0 = (p0(1) ** 2  + p0(2) ** 2) * 0.5d0

  q(1) = x
  q(2) = y
  x0 = x
  y0 = y
  u0 = -lppd
  
  ! Make a half step for momentum at the beginning

  dudq(1) = -dlp(1)
  dudq(2) = -dlp(2)
  

  
  ! Alternate full steps for position and momemtum
  do i = 1, l
     do j = 1, 2
        ! half step for p
        call diff_lppd(q(1), q(2), dlp)
        pp(j) = p(j) + eps * dlp(j) * 0.5d0
     end do
     do j = 1, 2
        ! full step for q
        qq(j) = q(j) + eps * pp(j)
        
        lim_check: do 
           if (qq(j) > qmax(j)) then
              qq(j) = qmax(j) - (qq(j) - qmax(j))
              pp(j) = -pp(j)
           else if (qq(j) < qmin(j)) then
              qq(j) = qmin(j) + (qmin(j) - qq(j))
              pp(j) = -pp(j)
           else
              exit lim_check
           end if
        end do lim_check
        q(j) = qq(j)
        p(j) = pp(j)
     end do
     do j = 1, 2
        ! half step for p
        call diff_lppd(q(1), q(2), dlp)
        p(j) = p(j) + eps * dlp(j) * 0.5d0
     end do
  end do
  
  call calc_lppd(q(1), q(2), lppd)
  u = -lppd
  k = (p(1) ** 2 + p(2) ** 2) * 0.5d0

  ! Judge
  !write(*,*)u0-u+k0-k
  !write(*,*)exp(-u + u0 - k + k0), u, u0, k, k0
  if (log(grnd()) <= -u + u0 - k + k0) then
     x = q(1)
     y = q(2)
     lppd = -u
  else
     x = x0
     y = y0
     lppd = -u0
  end if
  


  return 
end subroutine hmc



!============================================================
real(kind(0d0)) function gauss()
  use mt19937
  implicit none 
  real(8), parameter :: pi2 = 2.d0 * 3.1415926535897931d0
  real(8) :: v1, v2
  
  v1 = grnd() 
  v2 = grnd()
  gauss = sqrt(-2.d0 * log(v1)) * cos(pi2 * v2)
  
  
  return 
end function gauss
