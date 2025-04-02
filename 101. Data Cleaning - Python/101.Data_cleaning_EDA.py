# -*- coding: utf-8 -*-
"""
Created on Sat Mar 29 14:42:49 2025

@author: Shariq

Data cleaning project
"""

import pandas as pd
import os

os.getcwd()

os.listdir()

df = pd.read_excel('Customer Call List.xlsx')

# 1 drop duplicates--------------------------------------------------

duplicates = df[df.duplicated(keep = False)]

df = df.drop_duplicates()


# 2 remove columns-------------------------------------------------

print(df.info())

df = df.drop(columns = 'Not_Useful_Column')

# 3 Standardize cleaning values inside columns------------------------

# you could remove values individually

"""
df['Last_Name']= df['Last_Name'].str.lstrip('...')
df['Last_Name']= df['Last_Name'].str.lstrip('/')
df['Last_Name']= df['Last_Name'].str.rstrip('_')
"""

# or together but strip doesn't use [] instead just list them together

df['Last_Name']= df['Last_Name'].str.strip('123._/')

# to fix phone numbers we could also use an automated prosess
df['Phone_Number'] = df['Phone_Number'].str.replace('[^a-zA-Z0-9]', '')

# now we want to format it to a phone number 
# but to put the dashes we will first need to formate it to an str then float

df['Phone_Number'] = df['Phone_Number'].apply(lambda x: str(x))

# now to put it into format

df['Phone_Number'] = df['Phone_Number'].apply(lambda x: x[0:3] + '-' + x[3:6] + '-' + x[6:10])

# now to remove nan-- values

df['Phone_Number'] = df['Phone_Number'].str.replace('nan--', '')
df['Phone_Number'] = df['Phone_Number'].str.replace('Na--', '')

# now to fix address and put it into 3 columns

df[['Street_Address', 'State', 'Zip_Code']] = df['Address'].str.split(',',n=2, expand=True)

# fix Y and N
df['Paying Customer'] = df['Paying Customer'].str.replace('Yes','Y') 
df['Paying Customer'] = df['Paying Customer'].str.replace('No','N')

#fill na with blank and then remove blank values
df = df.fillna('')

print(df.info()) 

for x in df.index:
    if df.loc[x ,'Do_Not_Contact'] == '' :   # [row, col] n 
        df.drop(x, inplace = True)

for x in df.index:
    if df.loc[x ,'Phone_Number'] == '' :   # [row, col] n 
        df.drop(x, inplace = True)


# could have also used df.dropna(subset = 'phone _number')

# because this reuiend the index, need to reset it

df.reset_index(drop = True)  # drop = true removes the old index




