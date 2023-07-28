This coding session is based on [this notebook](https://github.com/ShivamShrirao/diffusers/blob/main/examples/dreambooth/DreamBooth_Stable_Diffusion.ipynb).  If you do not have a Myriad account, you can use this notebook on Google Colab instead.


### Instructions

To setup up Myriad and run your jobs just follow the following steps.   

1. You might not be connected by UCL network to which you need to conect to the UCL VPN for your OS:
  * [Linux](https://www.ucl.ac.uk/isd/how-to/connecting-to-ucl-vpn-linux),
  * [Windows, macOS, etc](https://www.ucl.ac.uk/isd/services/get-connected/ucl-virtual-private-network-vpn)

2. Make sure you can log in on the command line using `ssh ucaXXXX@myriad.rc.ucl.ac.uk` where ucaXXXX is your UCL username. Then use `exit` to log out.

3. Once you have logged into Myriad, clone this repo using `git clone https://github.com/dlcv-journal-club/TextToImageModels`

4. (Optional) If you have your own image that you want to finetune with, delete all existing images in the `data/zwx` directory, exit out of Myriad, and upload each of your photos your photos using `scp YOUR_PHOTO.png ucaXXXX@myriad.rc.ucl.ac.uk:~/PATH_TO_REPO/dreambooth/data/zwx`

5. (Optional) Log back into Myraid and navagate to the `stable_diffusion_weights/zwx`.  If your subject is anything other than a dog, you will need to change all instances of the word "dog" in the `concepts_list.json` file.  For example, if your subject is the empire state building, you may wont to change "dog" to "tower", or if you subject is a specific person you may want to change it to "person".  You can edit this file using `vim copncepts_list.json`.

6. The `inference.py` file contains a prompt that will be used to generate our final images. Alter this file using `vim inference.py`.  The the `prompt` variable on line 16 to something fun, but make sure to keep the words "photo of zwx CLASS_NAME" at the start of the prompt. By default CLASS_NAME will be "dog".

7. Queue you job using `qsub finetuning.qsub.sh`

8. Wait for the job to complete, one it's done you should see you images in the `imgs` directory
