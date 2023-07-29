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
#$ -N Dreambooth

# output directory for STDOUT file
#$ -o ~/runLog/

#########################/FLAGS#################################

#The code you want to run now goes here.

# print hostname and data for reference.
hostname
date
pwd

# I've found that I sometimes need to include the path to conda's libraries. No harm in including it.
export LD_LIBRARY_PATH=/home/$USER/miniconda3/lib/:${LD_LIBRARY_PATH}

# optionally activate your conda env here:
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python3/3.9-gnu-10.2.0
module load cuda/11.3.1/gnu-10.2.0
module load cudnn/8.2.1.32/cuda-11.3

source bin/activate
pip install torch
pip install -qq git+https://github.com/ShivamShrirao/diffusers
pip install -q -U --pre triton
pip install -q -U accelerate==0.21.0
pip install -q transformers ftfy bitsandbytes==0.35.0 gradio natsort safetensors xformers

pwd 
cd dreambooth
cd text_to_image_tutorial

python3 train_dreambooth.py \
  --pretrained_model_name_or_path="runwayml/stable-diffusion-v1-5" \
  --pretrained_vae_name_or_path="stabilityai/sd-vae-ft-mse" \
  --output_dir="stable_diffusion_weights/zwx" \
  --revision="fp16" \
  --with_prior_preservation --prior_loss_weight=1.0 \
  --seed=1337 \
  --resolution=512 \
  --train_batch_size=1 \
  --train_text_encoder \
  --mixed_precision="fp16" \
  --use_8bit_adam \
  --gradient_accumulation_steps=1 \
  --learning_rate=1e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --num_class_images=50 \
  --sample_batch_size=4 \
  --max_train_steps=800 \
  --save_interval=10000 \
  --save_sample_prompt="photo of zwx dog" \
  --concepts_list="concepts_list.json"

python3 convert_diffusers_to_original_stable_diffusion.py --model_path "stable_diffusion_weights/zwx/800"  --checkpoint_path "stable_diffusion_weights/zwx/800/model.ckpt" --half

python3 inference.py

# print hostname and date for reference again
hostname
date



# cleanup
# rm -r $COPYDIR

# give time for a clean exit.
sleep 10

date
