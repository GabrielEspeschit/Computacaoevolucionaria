def avaliar(fun, P):
    jP = []
    for i in range(len(P)):
        jP.append(fun(P[i][0], P[i][1]))

    return jP