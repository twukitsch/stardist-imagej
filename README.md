# StarDist ImageJ/Fiji Plugin

This is the ImageJ/Fiji plugin for [StarDist](https://github.com/mpicbg-csbd/stardist), which can be used to apply already trained models to new images.  
*Note: The plugin (currently) only supports 2D image and time lapse data.*

![Image description](static/stardist_screenshot_small.jpg)

See the [main repository](https://github.com/mpicbg-csbd/stardist) for links to our publications and the full-featured Python package that can also be used to train new models.


## Installation

The StarDist plugin can be installed in [Fiji](https://fiji.sc) by selecting both update sites [`CSBDeep`](https://sites.imagej.net/CSBDeep/) and [`StarDist`](https://sites.imagej.net/StarDist/).  
Concretely, you can follow these steps:

1. Start Fiji (or download and install it from [here](https://fiji.sc) first).
2. Select `Help > Update...` from the menu bar.
3. Click on the button `Manage update sites`.
4. Scroll down the list and tick the checkboxes for update sites `CSBDeep` and `StarDist`, then click the `Close` button.  
(If `StarDist` is missing, click `Update URLs` to refresh the list of update sites.)
6. Click on `Apply changes` to install the plugin.
7. Restart Fiji.


## Usage

[stardist-imagej/auto_process](https://github.com/twukitsch/stardist-imagej/tree/master/auto_process) contains automations complete with dialog box GUIs and a helpful guide for c-fos cell counting. (Special thanks to [The Rinker Lab at MUSC](https://github.com/RinkerLabMUSC) for allowing me to develop some of the first iterations of this.)
* STARDIST Automated Cell Counting Protocol.docx -- a helpful guide for c-fos cell counting when your entire image is to be cell counted.
* STARDIST Step0 - Split Color Channels.ijm -- quickly resolves issues with 3 channel (RGB) TIFFs and splits them into individual color channels.
* STARDIST Step1 - Preprocessing.ijm -- conveniently automates:
  * 8-bit conversion
  * Image Rescaling
  * Smoothing
  * Background Subtraction
  * Median Filtering
  * Contrast Enhancement
  * Sharpening
* STARDIST Step2 - STARDIST Model Processing.py -- (should be run from Fiji macro editor NOT python) this is handy [python script](https://gist.github.com/maweigert/8dd6ef139e1cd37b2307b35fb50dee4a) by [Martin Weigert](https://gist.github.com/maweigert) with minor modifcations shown here.
* STARDIST Step3 - Postprocessing.ijm -- automates postprocessing and cell counting steps and saves a dataset:
  * Thresholding
  * Converting to Mask
  * Watershedding
  * Analyze Particles (counting)


See the [wiki page](https://imagej.net/StarDist) for more information.

