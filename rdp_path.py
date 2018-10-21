"""
script to optimize path using
Ramer-Douglas-Peucker algorithm
"""

import pandas as pd
import rdp
import scipy.io
import numpy as np


# import list of coordinates
box_In = pd.read_csv("/Users/antonogorodnikov/Documents/Work/Python/Labels.csv")

# import coordinates for tumor
patient_In = pd.read_csv("/Users/antonogorodnikov/Documents/Work/Python/"
                                    "ProstateX-TrainingLesionInformationv2/!ProstateX-Images-Train.csv")

cond = patient_In['Name'].str.contains('ADC')
patient_ADC = patient_In.loc[cond,['ProxID', 'Name', 'ijk', 'Dim']].drop_duplicates(subset='ProxID')

# read stacks order
stack_ord_in = scipy.io.loadmat("/Users/antonogorodnikov/Documents/Work/Python/ADC_index.mat")
stack_ord_mat = stack_ord_in['ADC_index']
stack_ord_df = pd.DataFrame(stack_ord_mat)

# merge data
mer_dat = patient_ADC.merge(box_In, how='right', left_on = "ProxID", right_on = "Patient_ID")

# loop over the patients
for counter, patient in enumerate(mer_dat['ProxID'].unique()):

    # data frame of stacks and coordinates
    subset_mer = mer_dat.loc[mer_dat.ProxID == patient,:].reset_index(drop = True)
    subset_mer['order'] = stack_ord_df.loc[counter, :]
    subset_mer = subset_mer.sort_values(by='order').reset_index(drop = True)

    # make a lit of coordinates


    # loop over stacks
    for count_inner, i in subset_mer['order']:

        # make an array of coordinates
        x0 = list(range(84))
        y0 = 0
        z0 = count_inner

        if z == 0:
            continue










