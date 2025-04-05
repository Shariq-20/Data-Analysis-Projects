# -*- coding: utf-8 -*-
"""
Created on Sun Mar 30 02:12:57 2025

@author: Shariq
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

os.listdir()

edf = pd.read_csv('world_population.csv')

#pd.set_options('display.float_format', )

edf.describe()

edf.isnull().sum()

edf.nunique()

edf.sort_values(by = "World Population Percentage", ascending = False).head(10)


# finding corralation - but corr only takes numeric values

edf.dtypes()

edf2 = edf.drop(columns = ['CCA3','Country','Capital','Continent']) 

# could have also done edf.select_dtypes(include = 'number')

Corralation = edf2.corr()

# Creating a heatmap

sns.heatmap(Corralation, annot = True)
plt.rcParams['figure.figsize'] = (20,7)
plt.show()


# which continents have done well?
edf.groupby('Continent').mean()

edf[edf['Continent'].str.contains('Oceania')]

print(edf.columns)

edfx = edf.groupby('Continent')[['1970 Population',
       '1980 Population', '1990 Population', '2000 Population',
       '2010 Population', '2015 Population', '2020 Population',
       '2022 Population']].mean().sort_values(by="2022 Population", ascending =False)

edfx.plot()

tdf = edfx.transpose()
tdf.plot()



