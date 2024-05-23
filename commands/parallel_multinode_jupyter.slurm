#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:8
#SBATCH -J jupyter
#SBATCH -t 0-25

module load python/3.10

export JUPYTER_RUNTIME_DIR=/tmp
jupyter notebook --ip=$(hostname) --no-browser --port=8888
