#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o resire_PtNi_S.joblog.$JOB_ID.$TASK_ID
#$ -j y
# Edit the line below as needed
#$ -l h_data=10G,h_vmem=INFINITY,h_rt=220:00:00,highp,highmem
# #$ -q miao_*.q
# Add multiple cores/nodes as needed:
#$ -pe shared 4
# Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m bea
#$ -t 1-6:1

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load matlab
module li
echo " "
export MCR_CACHE_ROOT=$TMPDIR
echo MCR_CACHE_ROOT=$MCR_CACHE_ROOT
echo " "

# substitute the command to run your code below:
echo "matlab -nodisplay -nosplash -r \"cd `pwd`; resire_PtNi_S($SGE_TASK_ID); exit\" >> resire_PtNi_S.output.$JOB_ID.$SGE_TASK_ID"
matlab -nodisplay -nosplash -r "cd `pwd`; resire_PtNi_S($SGE_TASK_ID); exit" >> resire_PtNi_S.output.$JOB_ID.$SGE_TASK_ID

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

