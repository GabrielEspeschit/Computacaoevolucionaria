import numpy as np

def peaks(x1, x2):
    return 3*(1-x1)**2*np.exp(-(x1**2) - (x2+1)**2) - 10*(x1/5 - x1**3 - x2**5)\
        * np.exp(-x1**2 - x2**2) - 1/3*np.exp(-(x1+1)**2 - x2**2)
