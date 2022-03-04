function [offspring] = uniform_mutation(offspring, mutation_rate,  lower_bound, upper_bound)
%UNIFORM_MUTATION 此处显示有关此函数的摘要
%   此处显示详细说明
lenGene = size(offspring);
lenGene = lenGene(1);

mutate = rand([1, lenGene]);
mutate = mutate < mutation_rate;
offspring(:) = (1-offspring(:)).*mutate + offspring(:).*(1-mutate); % XOR operation

