# MCMC_Toy
Toy models for varioius MCMC methods, standard Markov-chain Mote Carlo (MCMC), Parallel tempering (PT), and Hamiltonian Monre Calro (HMC). Each progaram draws samples in accordance with a certain probability distribution p(x,y) expressed as below:




## MCMC
* command: `bin/mcmc_toy`
* output: `mcmc.out`

## Parallel Temperingj8bfu
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
