function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
nbPopulation = 10;
lenGene = 16;
population = randi([0,1], nbPopulation, lenGene);


% Evaluate the initial population
fitness = objective(bi2de(population, 'left-msb'));
nbEval = nbEval + nbPopulation;


% Record
fittest = 0;
for i = 1:nbPopulation
    if fittest(1) < fitness(i)
        fittest = [fitness(i),i];
    end
    if bestSoFarFit < fitness(i)
        bestSoFarFit = fitness(i);
        bestSoFarSolution = bi2de(population(i,:), 'left-msb');
    end
end
fitness_gen=[fitness_gen; bestSoFarFit];
solution_gen=[solution_gen; bestSoFarSolution];
fitness_pop = [fitness_pop; fittest];
nbGen = nbGen +1;

% Start the loop
while (nbEval<T) 
    % Roulette-wheel selection
    probability = fitness/sum(fitness);
    offspring = [];
    while size(offspring, 1) < nbPopulation
        parent1 = [];
        parent2 = [];
        r1 = rand();
        r2 = rand();
        rs = 0;
        for i = 1:nbPopulation
            rs = rs + probability(i);
            if r1 < rs
                parent1 = population(i,:);
                r1 = 2;
            end
            if r2 < rs
                parent2 = population(i,:);
                r2 = 2;
            end
        end 
        % One point crossover
        crossoverPoint = randi(lenGene-1);
        offspring = [offspring; [parent1(1:crossoverPoint), parent2(crossoverPoint+1:lenGene)]];
        offspring = [offspring; [parent2(1:crossoverPoint), parent1(crossoverPoint+1:lenGene)]];
    end
    offspring = offspring(1:nbPopulation, :);

    population = offspring;

    % Bit-flipping mutation
    mutationProb = 1/lenGene;
    for i = 1:nbPopulation
        r = rand();
        mutate = rand([1, lenGene]);
        mutate = mutate < r;
        offspring(i,:) = (1-offspring(i,:)).*mutate + offspring(i,:).*(1-mutate); % XOR operation
    end
    
    % Evaluate the polulation
    population = offspring;
    fitness = objective(bi2de(population, 'left-msb'));
    nbEval = nbEval + nbPopulation;
    nbGen = nbGen + 1;
    % Record
    fittest = 0;
    for i = 1:nbPopulation
        if fittest(1) < fitness(i)
            fittest = [fitness(i),i];
        end
        if bestSoFarFit < fitness(i)
            bestSoFarFit = fitness(i);
            bestSoFarSolution = bi2de(population(i,:), 'left-msb');
        end
    end
    fitness_gen=[fitness_gen; bestSoFarFit];
    solution_gen=[solution_gen; bestSoFarSolution];
    fitness_pop = [fitness_pop; fittest];
end
bestSoFarFit;
bestSoFarSolution;

figure,plot(1:nbGen,fitness_gen,'b') 
title('Fitness\_Gen')

figure,plot(1:nbGen,solution_gen,'b') 
title('Solution\_Gen')

figure,plot(1:nbGen,fitness_pop,'b') 
title('Fitness\_Pop')





