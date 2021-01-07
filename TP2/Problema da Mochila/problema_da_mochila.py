import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Classe Mochila para definir os parâmetros de inicialização e ficar fácil de mudar posteriormente
class Mochila:
    N = 8  # Número de Objetos
    cap = 35  # Capacidade
    wj = [10, 18, 12, 14, 13, 11, 8, 6]  # Peso
    vj = [5, 8, 7, 6, 9, 5, 4, 3]  # Valor

# Função para calcular o fitness de cada linha da matriz população
def fitness(solution, values, weights, cap):
    rho = max(np.divide(values, weights))
    total_benefit = np.dot(solution, values)
    total_weight = np.dot(solution, weights)
    if total_weight > cap:
        f = total_benefit - rho * (total_weight - cap)
    else:
        f = total_benefit
    return f

# Função para selecionar os pais usando o método da roleta
def sel_pais(prob, num_pais=2):
    current = 1
    a = []
    parent_index = []

    for i in range(len(prob)):
        if i == 0:
            a.append(prob[i])
        else:
            a.append(prob[i]+a[i-1])

    while current <= num_pais:
        r = np.random.rand(1)
        i = 0
        while a[i] < r:
            i += 1
        parent_index.append(i)
        current += 1
    return parent_index

# Função para fazer um cruzamento simples entre 2 indivíduos da população
def cruzamento(p1, p2):
    n = len(p1)
    pos = np.random.randint(1, n)
    f1 = np.concatenate([p1[0:pos], p2[pos:]])
    f2 = np.concatenate([p2[0:pos], p1[pos:]])

    return f1, f2

# Função principal de execução do programa
def mochila(it=1000, num_p=10, prob_def=0.8, prob_mut=0.02):
    # Inicialização do algoritmo
    iteracao = 0
    melhor = []
    media = []
    m1 = Mochila
    # Inicializando a população
    solution = np.random.randint(2, size=(num_p, m1.N))
    # Processo de iteração
    while iteracao < it:
        # Calculando o fitness
        fit = []
        for i in range(num_p):
            fit.append(fitness(solution[i], m1.vj, m1.wj, m1.cap))
        fit_prob = [(fit[i]/sum(fit)) for i in range(len(fit))]
        filhos = np.zeros((num_p, m1.N))
        aux_cruz = 0
        while aux_cruz < num_p-1:
            # Selecionando dois pais usando o metodo da roleta
            pais = sel_pais(fit_prob)
            # Fazendo o cruzamento
            prob_cross = np.random.rand(1)
            if prob_cross < prob_def:
                f1, f2 = cruzamento(solution[pais[0]], solution[pais[1]])
            else:
                f1, f2 = solution[pais[0]], solution[pais[1]]
            # Fazendo mutações aos filhos
            for i in range(m1.N):
                prob_m = np.random.rand(1)
                if prob_m < prob_mut:
                    f1[i] = int(not(f1[i]))
                    f2[i] = int(not(f2[i]))
            filhos[aux_cruz] = f1
            filhos[aux_cruz+1] = f2
            aux_cruz += 2
        # Acrescentando os filhos a população
        # Caso o fitness do íesimo filho for maior que o do íesimo membro, substitua-o
        for n in range(num_p-1):
            if fitness(filhos[n], m1.vj, m1.wj, m1.cap) > fit[n]:
                solution[n] = filhos[n]

        # Avaliando a população
        melhor.append(sorted(fit)[-1])
        media.append(sum(fit)/len(fit))
        print(f'Melhor: {sorted(fit)[-1]}\n Média:{sum(fit)/len(fit)} Geração: {iteracao}')
        iteracao += 1
    print(solution[fit.index(sorted(fit)[-1])])
    plt.plot(melhor, c='r')
    plt.plot(media, c='pink')
    green_patch = mpatches.Patch(color='r', label='Fitness do Melhor da Geração')
    blue_patch = mpatches.Patch(color='pink', label='Fitness médio da Geração')
    plt.legend(handles=[green_patch, blue_patch])
    # plt.plot(pior, c='r')
    plt.title(f'Desempenho por Geração \nProb. de Mutação: {prob_mut}\nProb. de Reproduzir:{prob_def}')
    plt.xlabel('Geração')
    plt.ylabel('Fitness')
    plt.show()

if __name__ == '__main__':
    mochila(it=1000, num_p=10, prob_def=0.8, prob_mut=0)
