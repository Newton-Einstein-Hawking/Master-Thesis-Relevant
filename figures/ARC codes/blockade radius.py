from arc import *
import numpy as np
import matplotlib.pyplot as plt

laserLinewidth = 2*np.pi*0.1e-3  # the unit is in GHz, where 0.1e-3 means 0.1 MHz
nList = np.arange(90,95)
c6List = []
blockadeRadiusList = []
for n in nList:
    calculation1 = PairStateInteractions(
        Rubidium(), n, 0, 0.5, n, 0, 0.5, 0.5, 0.5
    )
    state = printStateString(n, 0, 0.5) + " m_j= 1/2"
    c6 = calculation1.getC6perturbatively(0, 0, 5, 35e9)
    blockade = (abs(c6 / laserLinewidth)) ** (1 / 6.0)
    print("C_6 [%s] = %.0f GHz (mu m)^6\t%.1f mu m" % (state, c6, blockade))
    c6List.append(c6)
    blockadeRadiusList.append(blockade)