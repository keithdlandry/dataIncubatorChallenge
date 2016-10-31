# -*- coding: utf-8 -*-
"""
Created on Sun Oct 30 22:06:33 2016

@author: keithlandry
"""


from __future__ import division

import numpy as np
import pandas as pd
import random
import matplotlib.pyplot as plt

wrdata = pd.read_csv("/Users/keithlandry/dataIncubatorChallenge/wrStats.csv")
qbdata = pd.read_csv("/Users/keithlandry/dataIncubatorChallenge/qbStats.csv")
rbdata = pd.read_csv("/Users/keithlandry/dataIncubatorChallenge/rbStats.csv")
tedata = pd.read_csv("/Users/keithlandry/dataIncubatorChallenge/teStats.csv")

wrdataggr = wrdat.groupby("player").sum()
#get top 50 receivers by total fantasy points over the season
topWrs = wrdataggr.sort_values(by = 'fantasy_points', ascending = False)[0:50].index
topwrdat = wrdat[wrdat.player.isin(topWrs)]

len(topwrdat.player.unique())


qbdataggr = qbdat.groupby("player").sum()
topQbs = qbdataggr.sort_values(by = 'fantasy_points', ascending = False)[0:15].index
topqbdat = qbdat[qbdat.player.isin(topQbs)]


corrDiff   = []
uncorrDiff = [] 

for i in range(0,1000):

    #randomly pick game from qb
    index = random.randint(1,len(topqbdat))-1
    qbteam = topqbdat.iloc[index].team
    week = topqbdat.iloc[index].week
    qbPoints = topqbdat.iloc[index].fantasy_points
    
    if len(topwrdat[(topwrdat.team == qbteam) & (topwrdat.week == week)]) > 0:
        receiverPoints = topwrdat[(topwrdat.team == qbteam) & (topwrdat.week == week)].fantasy_points.sample(1)
        uncorRecPoints = topwrdat[(topwrdat.team != qbteam) | (topwrdat.week != week)].fantasy_points.sample(1)
    
    corrDiff.append(float(qbPoints-receiverPoints))
    uncorrDiff.append(float(qbPoints-uncorRecPoints))    
    
    
plt.hist(corrDiff)
plt.xlabel("fantasy points by qb - wr in same game on same team",fontsize=12)
plt.show()

plt.hist(uncorrDiff)
plt.xlabel("fantasy points by qb - random wr",fontsize=12)
plt.show()

print np.mean(corrDiff), np.std(corrDiff)
print np.mean(uncorrDiff), np.std(uncorrDiff)
    















