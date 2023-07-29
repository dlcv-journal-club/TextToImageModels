#   This is the most basic QSUB file needed for this cluster.
#   Further examples can be found under /share/apps/examples
#   Most software is NOT in your PATH but under /share/apps
#
#   For further info please read http://hpc.cs.ucl.ac.uk
#   For cluster help email cluster-support@cs.ucl.ac.uk
#
#   NOTE hash dollar is a scheduler directive not a comment.

#########################FLAGS#################################

# These are flags you must include - Two memory and one runtime.
# Runtime is either seconds or hours:min:sec

#$ -l mem=8G
#$ -l gpu=1

# only need 1 hour to test this script.
#$ -l h_rt=1:00:00

# choose your preferred shell.
#$ -S /bin/bash

# merge STDOUT and STDERROR
#$ -j y

# make sure you give it a memorable name
#$ -N Dreambooth_inference

# output directory for STDOUT file
#$ -o ~/runLog/

#########################/FLAGS#################################
set -e

#The code you want to run now goes here.

# print hostname and data for reference.
hostname
date
pwd

export LD_LIBRARY_PATH=/home/$USER/miniconda3/lib/:${LD_LIBRARY_PATH}

conda activate dreambooth

cd /home/cceajes/text_to_image/TextToImageModels/dreambooth

python3 inference.py --prompt "$MYPROMPT"

sleep 10

date
