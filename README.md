# MCMC_Toy
Toy models for varioius MCMC methods (MCMC, PT, and HMC).

## MCMC
* command: `bin/mcmc_toy`
* output: `mcmc.out`

## Parallel Tempering
* command: `mpirun -np 20 bin/pt_toy`
* output: `pt.out`

## Hamiltonian MC
* command: `bin/hmc_toy`
* output: `hmc.out`

## Install
* Just type `make`
* Needs `mpif90` that is linked to `gfortran` for PT

## Tuning parameter
* Can be tweak in `src/params.f90`
* Need re-compilation after changing parameters

## Output
* format: x, y, probability (w/o normalization constant)
