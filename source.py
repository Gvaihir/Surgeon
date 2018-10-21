"""
Program to find the most optimal path to the center of a tumor to perform laparoscopy

Milestones:

1) Available dataset: https://wiki.cancerimagingarchive.net/display/Public/SPIE-AAPM-NCI+PROSTATEx+Challenges#7a2690e0c25948c69ddda9cc3b3905ec
Tumor locations are available

2) Find CNN trained with abdomenal MRIs
    2.1) pixel intensities to vector
    2.2) PCA and t-SNE
    2.2) cluster analysis

3) Reconstruct optimal path

"""

import pandas as pd
import cv2
import numpy as np
import pydicom

if __name__ == "__main__":

    with open(argsP.i, 'r') as file:

        df_all = pd.DataFrame()

        # read file
        ds = pydicom.dcmread("/Users/antonogorodnikov/Documents/Work/Python/Prostate_ADC/9-7-ep2ddifftraDYNDISTADC-30502/000008.dcm")

        #make a flatten np array
        ds_flat = ds.pixel_array.flatten()

        # add to data frame

