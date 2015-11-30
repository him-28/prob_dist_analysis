%% Load the data matrices
%main;
load('gamma10.mat');
load('normal10.mat');
load('lognormal10.mat');

%% Which is a better distribution for each gene?
%we answer that by calculating the median of scores in each column(struct
%field) and comparing the three distributions. 

%also, when we answer that question, we might be in aposition to say which
%of the three distributions are better overall. 

fields = fieldnames(overall_fitness_Normal_10);
median_normal_10 = zeros(numel(fields),1);
median_lognormal_10 = zeros(numel(fields),1);
median_gamma_10 = zeros(numel(fields),1);

for i = 1:numel(fields)
    median_normal_10(i) = eval(sprintf('median(overall_fitness_Normal_10(:).%s)',fields{i}));
    median_gamma_10(i) = eval(sprintf('median(overall_fitness_Gamma_10(:).%s)',fields{i}));
    median_lognormal_10(i) = eval(sprintf('median(overall_fitness_Lognormal_10(:).%s)',fields{i}));
end

% next we find when one of the distributions is exclusively better
ind_normal = find(median_normal_10>median_lognormal_10 & median_normal_10>median_gamma_10);
ind_gamma = find(median_gamma_10>median_lognormal_10 & median_gamma_10>median_normal_10);
ind_lognormal = find(median_lognormal_10>median_normal_10 & median_lognormal_10>median_gamma_10);

figure;
subplot(3,2,1)
sum_length = length(ind_normal) + length(ind_gamma) + length(ind_lognormal);
X = [length(ind_normal) length(ind_gamma) length(ind_lognormal)]./sum_length;
explode = [1,1,1];
pie3(X,explode,{'Normal 27%','Gamma 36%','Lognormal 37%'});
title('Portion of genes when one of the distributions clearly fit the data better')

subplot(3,2,2)
Y = [length(ind_normal) length(ind_gamma) length(ind_lognormal) (length(median_gamma_10)-sum_length)]./length(median_gamma_10);
explode = [1,1,1,1];
pie3(Y,explode,{'Normal 25%','Gamma 34%','Lognormal 35%','Equal Scores 6%'});
title('Portion of genes explained by each distribution including when they gave equal scores')

%% What is the confidence when each of them is chosen as the best fit?
% we'll learn that through histograms 
subplot(3,2,3)
hist(median_normal_10(ind_normal),20)
title('Confidence when Normal was the best fit')

subplot(3,2,4)
hist(median_gamma_10(ind_gamma),20)
title('Confidence when Gamma was the best fit')

subplot(3,2,5)
hist(median_lognormal_10(ind_lognormal),20)
title('Confidence when Lognormal was the best fit')

%% Find a few examples where each of the distributions were best fitting
figure;
subplot(1,3,1)
eval(sprintf('hist(overall_fitness_Normal_10(:).%s)',fields{find(median_normal_10==1)}));
title('Best fitting normal')
subplot(1,3,2)
eval(sprintf('hist(overall_fitness_Gamma_10(:).%s)',fields{find(median_gamma_10==max(median_gamma_10))}));
title('Best fitting Gamma')
subplot(1,3,3)
eval(sprintf('hist(overall_fitness_Lognormal_10(:).%s)',fields{find(median_lognormal_10==max(median_lognormal_10))}));
title('Best fitting Lognormal')