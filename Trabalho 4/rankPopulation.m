function [rankedPop, rank] = rankPopulation(population, jobsTimes)
    tamPop = size(population,1);
    numJobs = size(jobsTimes,1);
    numMachines = size(jobsTimes,2);
    for index = 1:tamPop
        sequence = population(index, :);
        populationFitness(index) = fitness(sequence, jobsTimes, numJobs, numMachines);
    end
    [rankedPop, rank] = sort(populationFitness);
end