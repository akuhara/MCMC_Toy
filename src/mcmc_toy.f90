program main
  use mt19937
  use params
  implicit none 
  integer :: iter
  real(8) :: x, y, t, lppd

  x = x_ini
  y = y_ini
  t = 1.d0

  call sgrnd(iseed)
  call calc_lppd(x, y, lppd)


  open (10, file = "mcmc.out", status = "unknown")
  do iter = 1, nburn + niter
     
     if (mod(iter, 1000) == 0) then
        write(*,*)"Iteration:", iter, "/", nburn + niter
     end if
     
     call mcmc(x, y, t, lppd)
     if (iter > nburn .and. mod(iter, 1) == 0) then
        write(10,*)x, y, lppd
     end if
  end do
  close(10)
  
  stop
end program main
