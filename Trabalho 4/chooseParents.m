function [p1Index, p2Index] = chooseParents(popSize, prob, numPais)
    current = 1;
    parentIndex = zeros(1,numPais);
    a = zeros(1,popSize);
    for index = 1:popSize
        if index == 1
            a(index) = prob(index);
        else
            a(index) = prob(index) + a(index-1);
        end
    end
    while current <= numPais
        r = rand();
        i = 1;
        while a(i) < r
            i = i+1;
        end
        parentIndex(current) = i;
        current = current + 1;
    end 
    p1Index = parentIndex(1);
    p2Index = parentIndex(2);
end