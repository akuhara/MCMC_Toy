program main
  use params
  use mt19937
  implicit none
  include "mpif.h"
  integer :: status(MPI_STATUS_SIZE), ierr, rank, rank1, rank2
  integer :: iter, ipack(2), nchains, iseed2
  real(8) :: t1, lppd1, t2, lppd2, x, y
  real(8) :: rpack(2), xpack(3)
  logical :: yn

  call mpi_init(ierr)
  call mpi_comm_size(MPI_COMM_WORLD, nchains, ierr)
  call mpi_comm_rank(MPI_COMM_WORLD, rank,  ierr)
  
  
    
  x = x_ini
  y = y_ini
  t1 = exp((rank - 1) * log(t_max) / (nchains - 2))
  iseed2 = iseed  + rank * rank * 11002 + 590044 * rank
  call sgrnd(iseed2)
  call calc_lppd(x, y, lppd1)
  
  if (rank == 0) then
     open(10, file = "pt.out", status = "unknown")
  end if
  do iter = 1, nburn + niter
     if (rank > 0) then
        ! Child process
        
        ! MCMC step
        call mcmc(x, y, t1, lppd1)
        
        ! If T = 0, send current model to parent
        if (abs(t1 - 1.d0) < 1.d5) then
           xpack(1) = x
           xpack(2) = y
           xpack(3) = lppd1
           call mpi_send(xpack, 3, MPI_REAL8, 0, 1111, &
                & MPI_COMM_WORLD, status, ierr)
        end if

        ! Receive message regarding pair
        call mpi_bcast(ipack, 2, MPI_INTEGER4, 0, &
             & MPI_COMM_WORLD, ierr)
        rank1 = ipack(1)
        rank2 = ipack(2)

        
        if (rank == rank1) then
           ! receive message from pair
           call mpi_recv(rpack, 2, MPI_REAL8, rank2, 2018, &
                & MPI_COMM_WORLD, status, ierr)
           t2 = rpack(1)
           lppd2 = rpack(2)

           call judge_pt(t1, t2, lppd1, lppd2, yn)
           if (yn) then
              rpack(1) = t1
              t1 = t2
           end if
           
           call mpi_send(rpack, 1, MPI_REAL8, rank2, 1988, &
                & MPI_COMM_WORLD, status, ierr)

        else if (rank == rank2) then
           ! send message to pair
           rpack(1) = t1
           rpack(2) = lppd1
           call mpi_send(rpack, 2, MPI_REAL8, rank1, 2018, &
                & MPI_COMM_WORLD, status, ierr)

           call mpi_recv(rpack, 1, MPI_REAL8, rank1, 1988, &
                & MPI_COMM_WORLD, status, ierr)
           t1 = rpack(1)

        end if
        
     else 
        ! rank 0: record T == 1.0 chain
        call mpi_recv(xpack, 3, MPI_REAL8, MPI_ANY_SOURCE, 1111, &
              & MPI_COMM_WORLD, status, ierr)  
        x = xpack(1)
        y = xpack(2)
        lppd1 = xpack(3)

        if (iter > nburn .and. mod(iter, 1) == 0) then
           write(10,*)x, y, lppd1
        end if
        if (mod(iter, 1000) == 0) then
           write(*,*)"Iteration:", iter, "/", nburn + niter
        end if
     
        ! rank 0: select pair
        rank1 = int(grnd() * (nchains - 1)) + 1
        do 
           rank2 = int(grnd() * (nchains - 1)) + 1
           if (rank2 /= rank1) exit 
        end do

        ipack(1) = rank1
        ipack(2) = rank2

        call mpi_bcast(ipack, 2, MPI_INTEGER4, 0, &
             & MPI_COMM_WORLD, ierr)
     end if
  end do
  
  close(10)
  
  call mpi_finalize(ierr)

  stop
end program main

!=======================================================================

subroutine judge_pt(temp1, temp2, lp1, lp2, yn)
  use mt19937
  implicit none 
  real(kind(0d0)), intent(in) :: temp1, temp2, lp1, lp2
  logical, intent(out) :: yn
  real(kind(0d0)) :: del_s
  
  del_s = (lp2 - lp1) * (1.d0 / temp1 - 1.d0 / temp2)
  yn = .false.

  if(log(grnd()) <= del_s) then
     yn = .true.
  end if
  
  return 
end subroutine judge_pt

