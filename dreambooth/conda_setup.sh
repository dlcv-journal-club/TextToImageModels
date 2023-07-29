echo $SHELL

export LD_LIBRARY_PATH=/home/$USER/miniconda3/lib/:${LD_LIBRARY_PATH}


# Run once to create this conda env:
# conda create -n dreambooth pip
# Then source this file.

conda activate dreambooth
conda install cudatoolkit
pip install torch
pip install -qq git+https://github.com/ShivamShrirao/diffusers
pip install -q -U --pre triton
pip install -q -U accelerate==0.21.0
pip install -q transformers ftfy bitsandbytes==0.35.0 gradio natsort safetensors xformers
pip install -q torchvision



