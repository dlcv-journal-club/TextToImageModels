This coding session is based on [this notebook](https://github.com/ShivamShrirao/diffusers/blob/main/examples/dreambooth/DreamBooth_Stable_Diffusion.ipynb).  If you do not have a Myriad account, you can use this notebook on Google Colab instead.


### Instructions

To setup Myriad and run your jobs just follow the following steps.

1. You might not be connected by UCL network to which you need to conect to the UCL VPN for your OS:
  * [Linux](https://www.ucl.ac.uk/isd/how-to/connecting-to-ucl-vpn-linux),
  * [Windows, macOS, etc](https://www.ucl.ac.uk/isd/services/get-connected/ucl-virtual-private-network-vpn)

2. Log in using the command line `ssh ucaXXXX@myriad.rc.ucl.ac.uk`, where `ucaXXXX` is your UCL username.

3. Once you have logged into Myriad, clone this repo using `git clone https://github.com/dlcv-journal-club/TextToImageModels`, and `cd` into the `~/PATH_TO_REPO/TextToImageModels/dreambooth` directory.

4. Create a conda env which contains `pip` and then set it up
    - `conda create -n dreambooth pip`
    - Run `source conda_setup.sh` to setup the conda env.

5. (Optional) If you have your own images that you want to finetune with, delete all existing images in the `data/zwx` directory. Then in another window, upload each of your photos using `scp YOUR_PHOTO.png ucaXXXX@myriad.rc.ucl.ac.uk:~/PATH_TO_REPO/dreambooth/data/zwx`.

6. (Optional) Switch back to your Myriad ssh session. If your subject is anything other than a dog, you will need to change all instances of the word "dog" in the `concepts_list.json` file. For example, if your subject is the Empire State Building, you may want to change "dog" to "tower", or if your subject is a specific person, you may want to change it to "person". You can edit this file using `vim concepts_list.json`.

7. The `inference.py` file contains a prompt that will be used to generate our final images. Alter this file using `vim inference.py`. Change the `prompt` variable on line 16 to something fun, but make sure to keep the words "photo of zwx CLASS_NAME" at the start of the prompt. By default, CLASS_NAME will be "dog".

8. Edit `finetuning.qsub.sh` and review the contents:
    - Make sure the output directory under `#$ -o ~/FOO/` exists.
    - delete `source bin/activate`, replace with `conda activate dreambooth` (the conda env you created earlier).
    - Make sure it `cd`s to the correct location of the `dreambooth` directory    - The `--save_sample_prompt` option should be changed if the input images are not of a dog, as in previous steps. Eg. `--save_sample_prompt="photo of zwx tower"`

9. Queue your job using `qsub finetuning.qsub.sh`.

10. Wait for the job to complete; once it's done, you should see your images in the `imgs` directory.
