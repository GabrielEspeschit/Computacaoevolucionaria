function [makespan] = fitness(jobsSequence, jobsTimes, numJobs, numMachines)
    for (i = 1:numMachines)
        for (j = 1:numJobs) 
            matrizAux(i,j) = jobsTimes(jobsSequence(j),i);
        end
    end
    makeTable = zeros([numMachines numJobs]);
    makeTable(1,1) = matrizAux(1,1);
    
    
    for (row = 2:numMachines)
        for (col = 2:numJobs)
            % 1 Job
            makeTable(1,col) = makeTable(1,col-1) + matrizAux(1,col);
            % 1 maquina
            makeTable(row,1) = makeTable(row-1,1) + matrizAux(row,1);
        end
    end
    
    for (row = 2:numMachines)
        for (col = 2:numJobs)
            if makeTable(row,col-1) > makeTable(row-1,col)
                makeTable(row,col) = makeTable(row,col-1) + matrizAux(row,col);
            else 
                makeTable(row,col) = makeTable(row-1,col) + matrizAux(row,col);
        end
    end 
    makespan = makeTable(numMachines,numJobs);
end