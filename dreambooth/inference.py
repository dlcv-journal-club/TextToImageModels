import argparse
import os
from datetime import datetime
import torch
from torch import autocast
from diffusers import StableDiffusionPipeline, DDIMScheduler

model_path = 'stable_diffusion_weights/zwx/800'             

parser = argparse.ArgumentParser(description="Run inference")
parser.add_argument(
    "--prompt",
    type=str,
    default=None,
    required=False,
    help="prompt",
)
args = parser.parse_args()

pipe = StableDiffusionPipeline.from_pretrained(model_path, safety_checker=None, torch_dtype=torch.float16).to("cuda")
pipe.scheduler = DDIMScheduler.from_config(pipe.scheduler.config)
pipe.enable_xformers_memory_efficient_attention()
g_cuda = None

g_cuda = torch.Generator(device='cuda')
seed = 52362 #@param {type:"number"}
g_cuda.manual_seed(seed)

prompt = "photo of zwx dog in a bucket" #@param {type:"string"}
if args.prompt is not None:
    prompt = args.prompt
negative_prompt = "" #@param {type:"string"}
num_samples = 4 #@param {type:"number"}
guidance_scale = 7.5 #@param {type:"number"}
num_inference_steps = 24 #@param {type:"number"}
height = 512 #@param {type:"number"}
width = 512 #@param {type:"number"}

with autocast("cuda"), torch.inference_mode():
    images = pipe(
        prompt,
        height=height,
        width=width,
        negative_prompt=negative_prompt,
        num_images_per_prompt=num_samples,
        num_inference_steps=num_inference_steps,
        guidance_scale=guidance_scale,
        generator=g_cuda
    ).images

subdir = f'imgs/{datetime.now().strftime("%Y%m%dT%H%M%S")}'
os.makedirs(subdir)
for counter, img in enumerate(images):
    #display(img)
    img.save(f"{subdir}/img" + str(counter) + '.jpg')

with open(f'{subdir}/prompt.txt', 'w') as prompt_out:
    print(prompt, file=prompt_out)
