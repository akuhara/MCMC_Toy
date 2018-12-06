module params
  implicit none 

  ! General
  integer, parameter :: iseed = 12131415
  integer, parameter :: nburn = 10000, niter = 100000
  real(8), parameter :: dx = 0.5, dy = 0.5
  real(8), parameter :: x_min = -1.d0, x_max = 1.d0
  real(8), parameter :: y_min = -1.d0, y_max = 1.d0
  real(8), parameter :: x_ini = -0.7d0, y_ini = 0.7d0

  ! Parallel Tempering
  real(8), parameter :: t_max = 30.d0

  ! Hamilon MC
  real(8), parameter :: eps = 0.03d0
  integer, parameter :: l = 60
  
end module params
