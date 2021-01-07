function [makespan, sequence, avgMakespan, bestMakespan ] = JSSP(fileName)
    close all;
    clc
    
    %Exemplo de uso: [makespan, sequence, avgMakespan, bestMakespan] = JSSP('entrada_3.txt');
    % Leitura dados de entrada da funcao
    jobsScheduleMatrix = dlmread(fileName);
    numJobs = size(jobsScheduleMatrix,1);
    numMachines = size(jobsScheduleMatrix,2);
    
    % Inicializacao Populacao
    tamPop = 40;
    population = initializePopulation(tamPop, numJobs);
    
    %Algoritmo Genetrico
    geracao = 1 ;
    maxGeracoes = 400;
    probMutacao = 0.2;

    while geracao <= maxGeracoes

        % Calculando o fitness
        populationFitness = zeros(1,tamPop);
        for index = 1:tamPop
            sequence = population(index, :);
            populationFitness(index) = fitness(sequence, jobsScheduleMatrix, numJobs, numMachines);
        end
        populationFitness = 1./populationFitness;
        normalizedFitness = populationFitness./sum(populationFitness);
        
        % Cruzamento
        auxCruz = 1;
        popProx = zeros(tamPop, numJobs);
        while auxCruz < tamPop 
            [p1, p2] = chooseParents(tamPop, normalizedFitness, 2);
            parents(1,:)= population(p1,:) ;
            parents(2,:) = population(p2,:);
            children = CutAndCrossfill_Crossover(parents);
             
            %Mutacao
            for child = 1:2 
                if (rand() < probMutacao)
                    aux1 = randi([1 numJobs], 1,1);
                    sortedIndex = randi([1 numJobs], 1,1);
                    while sortedIndex == aux1 
                        sortedIndex = randi([1 numJobs], 1,1);
                    end
                    aux2 = sortedIndex;
                    aux = children(child, aux1);
                    children(child,aux1) = children(child,aux2);
                    children(child,aux2) = aux;
                end
            end
            popProx(auxCruz, :) = children(1, :);
            popProx(auxCruz + 1, :) = children(2, :);
            auxCruz = auxCruz + 2;
        end
        for n = 1:tamPop
            fitPai = fitness(population(n, :), jobsScheduleMatrix, numJobs, numMachines);
            fitFilho = fitness(popProx(n, :), jobsScheduleMatrix, numJobs, numMachines);
            if fitFilho <= fitPai
                population(n,:) = popProx(n,:);
            end
        end
       
        %Avaliacao Populacao
        [populationRankedFit, populationRanked] = rankPopulation(population,jobsScheduleMatrix);
        avgMakespan(geracao) = median(populationRankedFit);
        bestMakespan(geracao) = populationRankedFit(1);
        bestSequence(geracao, :) = population(populationRanked(1),:);
        geracao = geracao + 1
        
        if geracao >= maxGeracoes/10
            contEqual = 0 ;
            i = 1;
            while i < geracao-1 
                if bestMakespan(i) == bestMakespan(i+1)
                    contEqual = contEqual + 1;
                else 
                    break
                end
                i = i + 1;
            end
            if contEqual >= maxGeracoes/10
                break
            end
        end
    end
    
    lowerMakespanIndex = 1 ;
    for ger = 2:size(bestMakespan,2)
        if bestMakespan(lowerMakespanIndex) > bestMakespan(ger)
            lowerMakespanIndex = ger;
        end
    end
    sequence = bestSequence(lowerMakespanIndex, :);
    makespan = bestMakespan(lowerMakespanIndex);
    
    figure(1)
    plot(bestMakespan, 'r');
    hold on;
    plot(avgMakespan, 'b');
    hold on;
    xlabel('Geração');
    ylabel('Makespan');
    legend('bestMakespan', 'avgMakespan');
    title('Fitness x Geração');
    grid on;
    
end