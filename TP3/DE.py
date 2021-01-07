import numpy as np
import random
import peaks, rastrigin, plotar, avaliar
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

if __name__ == '__main__':

    # Definindo variáveis
    geracao = 0
    lb = [-3, -3]
    ub = [3, 3]
    max_ger = 1001
    num_pop = 100
    C = 0.6
    F = 0.9

    melhor = []
    media = []
    funcao = rastrigin.rastrigin
    #funcao = peaks.peaks
    pop = np.random.uniform(low=lb[0], high=ub[0], size=(num_pop, 2))
    prox_gen = pop

    # Inicia o ciclo do DE
    while geracao < max_ger:
        # print(pop, f'\n Geração: {geracao}')
        for i in range(num_pop):
            # Selecionar aleatóriamente r1, r2 e r3
            ind_r1, ind_r2, ind_r3 = random.sample(range(0, num_pop), 3)
            r1, r2, r3 = [pop[ind_r1][0], pop[ind_r1][1]], [pop[ind_r2][0], pop[ind_r2][1]], [pop[ind_r3][0], pop[ind_r3][1]]
            # print(f'Geração: {geracao}\nr1:{r1}\nr2:{r2}\nr3:{r3}')
            # Criar população de filhos
            u = np.zeros(2)
            for j in range(2):
                delta = np.random.randint(0, high=2, size=1)
                if random.random() < C and j == delta:
                    u[j] = r1[j] + F*(r2[j] - r3[j])
                    if u[j] > ub[0]:
                        u[j] = ub[0]
                    elif u[j] < lb[0]:
                        u[j] = lb[0]
                else:
                    u[j] = r1[j]
            # Substituir
            if funcao(u[0], u[1]) <= funcao(r1[0], r1[1]):
                prox_gen[ind_r1] = u
        # Avaliamos a população
        pop = prox_gen
        jp = avaliar.avaliar(funcao, pop)
        media.append(sum(jp)/num_pop)
        melhor.append(min(jp))
        if geracao % 100 == 0:
            plotar.plotar(funcao, lb, ub, pop, jp, geracao)
        geracao += 1
    # Plotamos os valores finais
    plt.close()
    plt.clf()
    plt.plot(melhor, c='r')
    plt.plot(media, c='pink')
    green_patch = mpatches.Patch(color='r', label='Fitness do Melhor da Geração')
    blue_patch = mpatches.Patch(color='pink', label='Fitness médio da Geração')
    plt.legend(handles=[green_patch, blue_patch])
    plt.title('Desempenho geral do algoritmo')
    plt.show()
