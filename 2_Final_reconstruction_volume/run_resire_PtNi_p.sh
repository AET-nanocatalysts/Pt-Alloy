#!/bin/bash
#SBATCH --partition=amd-ep2
#SBATCH --qos=normal
#SBATCH -J Main_RESIRE_sample
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=100G
#SBATCH -o Main_RESIRE_sample.joblog.%J

# echo job info on joblog:
echo "Job $JOBID started on:   " `hostname -s`
echo "Job $JOBID started on:   " `date `
echo " "

# load the job environment:
module load matlab

# substitute the command to run your code below:
echo "matlab -nodesktop -nodisplay -nosplash -r \"cd `pwd`; Main_RESIRE_sample; exit\" >> Main_RESIRE_sample.output.$SLURM_JOB_ID"
matlab -nodesktop -nodisplay -nosplash -r "cd `pwd`; Main_RESIRE_sample; exit" >> Main_RESIRE_sample.output.$SLURM_JOB_ID

# echo job info on joblog:
echo "Job $SLURM_JOB_ID ended on:   " `hostname -s`
echo "Job $SLURM_JOB_ID ended on:   " `date `
echo " "

