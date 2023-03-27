#!/bin/bash
#SBATCH --partition=amd-ep2
#SBATCH --qos=normal
#SBATCH -J resire_PtNi_S
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=100G
#SBATCH -a 1-6:1
#SBATCH -o resire_PtNi_S.joblog.%J.%a

# echo job info on joblog:
echo "Job $JOBID started on:   " `hostname -s`
echo "Job $JOBID started on:   " `date `
echo " "

# load the job environment:
module load matlab

# substitute the command to run your code below:
echo "matlab -nodisplay -nosplash -r \"cd `pwd`; resire_PtNi_S($SLURM_ARRAY_TASK_ID); exit\" >> resire_PtNi_S.output.$SLURM_ARRAY_JOB_ID.$SLURM_ARRAY_TASK_ID"
matlab -nodisplay -nosplash -r "cd `pwd`; resire_PtNi_S($SLURM_ARRAY_TASK_ID); exit" >> resire_PtNi_S.output.$SLURM_ARRAY_JOB_ID.$SLURM_ARRAY_TASK_ID

# echo job info on joblog:
echo "Job $JOBID ended on:   " `hostname -s`
echo "Job $JOBID ended on:   " `date `
echo " "

