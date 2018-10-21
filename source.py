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
from os import listdir
from os.path import isfile, join
import os

from sklearn.decomposition import PCA
from sklearn.manifold import TSNE

import ggplot


if __name__ == "__main__":

    df_all = pd.DataFrame()

    root = '/Users/antonogorodnikov/Documents/Work/Python/Prostate_ADC/'

    for path, subdirs, file in os.walk(root):
        for name in file:
            if ".dcm" in name:
                file_path = os.path.join(path, name)

                # read file
                ds = pydicom.dcmread(file_path)

                # make a flatten np array
                ds_flat = ds.pixel_array.flatten()

                # add to data frame
                df_all['/'.join(file_path.split('/')[-2:])] = ds_flat

                df_all = df_all/255.0

                rndperm = np.random.permutation(df_all.shape[0])

                pca_100 = PCA(n_components=100)

                pca_result_100 = pca_100.fit_transform(df_all.values)

                print('Cumulative explained variation for 50 principal components: {}'.format(
                    np.sum(pca_100.explained_variance_ratio_)))

                time_start = time.time()
                tsne = TSNE(n_components=2, verbose=1, perplexity=40, n_iter=300)
                tsne_pca_results = tsne.fit_transform(pca_result_100[rndperm])

                print
                't-SNE done! Time elapsed: {} seconds'.format(time.time() - time_start)


