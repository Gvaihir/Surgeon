"""
Program to find the most optimal path to the center of a tumor to perform laparoscopy

Milestones:

1) Available dataset: https://wiki.cancerimagingarchive.net/display/Public/SPIE-AAPM-NCI+PROSTATEx+Challenges#7a2690e0c25948c69ddda9cc3b3905ec
Tumor locations are available

2) Find CNN trained with abdomenal MRIs
    2.1) Segment images for detection of an important organ
    2.2) determine location of the organ (coordinates of the object edges

3) Reconstruct optimal path

"""

import pandas as pd
