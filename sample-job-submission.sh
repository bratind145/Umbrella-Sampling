#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=40
#SBATCH --time=60:00:00
#SBATCH --job-name=FrameXXXX
#SBATCH --error=gromacs.%J.err
#SBATCH --output=gromacs.%J.out
#SBATCH --partition=cpu
#======================================
ulimit -s unlimited
export OMP_NUM_THREADS=1
module load openmpi/4.1.1
. /home/apps/spack/share/spack/setup-env.sh
spack load gromacs@2022.2
#======================================
mpirun -np 1 gmx_mpi grompp -f npt-umbrella.mdp -c confXXXX.gro -r confXXXX.gro -p topol.top -n index.ndx -o npt-umXXXX.tpr -maxwarn 2
mpirun -np 40 gmx_mpi mdrun -s npt-umXXXX.tpr -deffnm npt-umXXXX -v
mpirun -np 1 gmx_mpi grompp -f md-umbrella.mdp -c npt-umXXXX.gro -r npt-umXXXX.gro -p topol.top -t npt-umXXXX.cpt -n index.ndx -maxwarn 2 -o md-umXXXX.tpr
mpirun -np 40 gmx_mpi mdrun -v -s md-umXXXX.tpr -deffnm md-umXXXX
#mpirun -np 1 gmx_mpi convert-tpr -s md-um0.tpr -o md-um0-N1.tpr -extend 50000
#mpirun -np 40 gmx_mpi mdrun -v -s md-um0-N1.tpr -deffnm md-um0 -cpi md-um0.cpt -pf md-um0_pullf.xvg -px md-um0_pullx.xvg -append
