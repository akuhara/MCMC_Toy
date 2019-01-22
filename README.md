# MCMC_Toy
Toy models for varioius MCMC methods, standard Markov-chain Mote Carlo (MCMC), Parallel tempering (PT), and Hamiltonian Monre Calro (HMC). Each progaram draws samples in accordance with a certain probability distribution p(x,y) expressed as below:

<img src="https://latex.codecogs.com/gif.latex?\dpi{200}&space;\fn_cm&space;\tiny&space;p(x,y)\propto&space;\exp(-\sqrt{x^2&plus;y^2})\left\{&space;\cos^2(12\sqrt{x^2&plus;y^2})&plus;0.01&space;\right\}^{10},&space;-1\le&space;x&space;\le&space;1,&space;-1\le&space;y&space;\le&space;1&space;." title="\tiny p(x,y)\propto \exp(-\sqrt{x^2+y^2})\left\{ \cos^2(12\sqrt{x^2+y^2})+0.01 \right\}^{10}, -1\le x \le 1, -1\le y \le 1 ." />


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
