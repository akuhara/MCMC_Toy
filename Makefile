FC      = gfortran
MF90    = mpif90


# GNU fortran compiler
#FFLAGS = -ffast-math -march=native -mtune=native -O3 -fno-range-check

# GNU fortran compiler (for debug)
 FFLAGS = -pg -Wall -pedantic -std=f95 -fbounds-check -O -Wuninitialized \
            -ffpe-trap=invalid,zero,overflow -fbacktrace \
            -fno-range-check 

# Intel compiler
# FFLAGS = -O3 -parallel -assume byterecl


# Intel compiler (for debug)
# #FFLAGS = -O0 -g -traceback -CB -fpe0 -check uninit -std -warn all \
            -check all -assume byterecl


MPI       = -DMPI=1 

BINDIR    = ./bin
MCMC      = $(BINDIR)/mcmc_toy
PT        = $(BINDIR)/pt_toy
HMC       = $(BINDIR)/hmc_toy
OBJS_COMM = src/params.o src/mcmc.o src/prop_model.o \
	    src/mt19937.o src/judge.o src/calc_lppd.o
OBJS_MCMC = src/params.o src/mcmc.o src/prop_model.o \
	    src/mt19937.o src/judge.o src/calc_lppd.o \
            src/mcmc_toy.o
OBJS_PT   = src/params.o src/mcmc.o src/prop_model.o \
	    src/mt19937.o src/judge.o src/calc_lppd.o \
            src/pt_toy.o
OBJS_HMC  = src/params.o src/hmc_toy.o \
	    src/mt19937.o src/calc_lppd.o src/diff_lppd.o\
            src/hmc.o 
OBJS_ALL  = src/params.o src/mcmc.o src/prop_model.o \
	    src/mt19937.o src/judge.o src/calc_lppd.o \
            src/hmc.o src/diff_lppd.o \
            src/mcmc_toy.o src/pt_toy.o src/hmc_toy.o 

all: $(MCMC) $(PT) $(HMC)

$(MCMC): $(OBJS_MCMC)
	@if [ ! -d $(BINDIR) ]; then mkdir $(BINDIR); fi
	$(FC) $(FFLAGS) $^ -o $@ 

$(PT): $(OBJS_PT)
	@if [ ! -d $(BINDIR) ]; then mkdir $(BINDIR); fi
	$(MF90) $(FFLAGS) $(MPI) $^ -o $@ 

$(HMC): $(OBJS_HMC)
	@if [ ! -d $(BINDIR) ]; then mkdir $(BINDIR); fi
	$(FC) $(FFLAGS) $(MPI) $^ -o $@ 

src/prop_model.o: params.mod mt19937.mod
src/judge.o: mt19937.mod
src/mcmc_toy.o: params.mod
src/pt_toy.o: params.mod mt19937.mod
src/mcmc.o: params.mod
src/hmc.o: params.mod mt19937.mod
src/hmc_toy.o: params.mod mt19937.mod
clean: 
	-rm -f *.mod src/*.o

# General rule
$(OBJS_ALL): %.o: %.f90
	$(MF90) $(FFLAGS) -c $< -o $*.o 
%.mod: src/%.f90 src/%.o
	@:

