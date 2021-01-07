import matplotlib.pyplot as plt
import numpy as np
from peaks import peaks
plt.style.use('seaborn-white')


def plotar(fun, lb, ub, P, jP, g):
    if len(lb) == 2:
        plt.clf()
        x = np.linspace(lb[0], ub[0])
        y = np.linspace(lb[1], ub[1])
        X, Y = np.meshgrid(x, y)
        Z = fun(X, Y)
        plt.contour(X, Y, Z, levels=20)
        plt.scatter(*zip(*P), c='black', marker='o')
        plt.title(f'Algoritmo Genetico Simples, Geração: {g}')
        plt.xlabel('x1')
        plt.ylabel('x2')
        plt.pause(2)
    value = jP.index(min(jP))
    print(f'Geração: {g}\nFitness: {fun(P[value][0], P[value][1])}\nMelhor: {P[value][0], P[value][1]}')
