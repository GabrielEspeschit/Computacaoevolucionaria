function [initialPop] = initializePopulation(tamPop, numJobs)
    initialPop = zeros(tamPop,numJobs);
    for (index = 1:tamPop)
        rand = randperm(numJobs);
        initialPop(index,:) = rand;
    end
end 