%% Load the data matrices
%main;
load('gamma10.mat');
load('normal10.mat');
load('lognormal10.mat');

%% Which is a better distribution for each gene?
%we answer that by calculating the area under the curve for the following
%curve: number of conditions that are greater than a certain threshold vs
%the threshold. we normalize the area too. 

%also, when we answer that question, we might be in a position to say which
%of the three distributions are better overall. 

fields = fieldnames(overall_fitness_Normal_10);
auc_normal_10 = zeros(numel(fields),1);
auc_lognormal_10 = zeros(numel(fields),1);
auc_gamma_10 = zeros(numel(fields),1);

for i = 1:numel(fields)
    auc_normal_10(i) = eval(sprintf('auc(overall_fitness_Normal_10(:).%s)',fields{i}));
    auc_gamma_10(i) = eval(sprintf('auc(overall_fitness_Gamma_10(:).%s)',fields{i}));
    auc_lognormal_10(i) = eval(sprintf('auc(overall_fitness_Lognormal_10(:).%s)',fields{i}));
end

% next we find when one of the distributions is exclusively better. to that
% end, we first find the area under the curve for each gene, with each
% distribution.

auc_sum = auc_normal_10 + auc_gamma_10 + auc_lognormal_10;
auc_nn = zeros(size(auc_sum));
auc_gn = zeros(size(auc_sum));
auc_lnn = zeros(size(auc_sum));
for i = 1:size(auc_sum)
    auc_nn(i) = auc_normal_10(i)/auc_sum(i);
    auc_gn(i) = auc_gamma_10(i)/auc_sum(i);
    auc_lnn(i) = auc_lognormal_10(i)/auc_sum(i);
end

%to check for exclusivity, we find how many of the genes are better in a
%way that atleast half of the conditions are best explained by that gene. 
ind_normal = find(auc_nn >= 0.5);
ind_gamma = find(auc_gn >= 0.5);
ind_lognormal = find(auc_lnn >= 0.5);
% figure;
% %subplot(3,2,1)
sum_length = length(ind_normal) + length(ind_gamma) + length(ind_lognormal);
% X = [length(ind_normal) length(ind_gamma) length(ind_lognormal)]./sum_length;
% explode = [1,1,1];
% pie3(X,explode,{'Normal 27%','Gamma 36%','Lognormal 37%'});
% title('Portion of genes when one of the distributions fits the data better')
% 
 figure;
% %subplot(3,2,2)
Y = [length(ind_normal) length(ind_gamma) length(ind_lognormal) (length(auc_gamma_10)-sum_length)]./length(auc_gamma_10);
explode = [1,1,1,1];
pie3(Y,explode,{'Normal 5','Gamma 0','Lognormal 6','Equal Scores 4085'});
% title('Portion of genes explained by each distribution including the genes for which they gave equal scores')
% 
% %% What is the confidence when each of them is chosen as the best fit?
% % we'll learn that through histograms 
% figure;
% %subplot(3,2,3)
% hist(auc_normal_10(ind_normal),20)
% title('Scores when Normal was the best fit')
% 
% figure;
% %subplot(3,2,4)
% hist(auc_gamma_10(ind_gamma),20)
% title('Scores when Gamma was the best fit')
% 
% figure;
% %subplot(3,2,5)
% hist(auc_lognormal_10(ind_lognormal),20)
% title('Scores when Lognormal was the best fit')
% 
% %% Find a few examples where each of the distributions were best fitting
% figure;
% %subplot(1,3,1)
% eval(sprintf('hist(overall_fitness_Normal_10(:).%s)',fields{find(auc_normal_10==1)}));
% title('Best fitting normal example')
% 
% figure;
% %subplot(1,3,2)
% eval(sprintf('hist(overall_fitness_Gamma_10(:).%s)',fields{find(auc_gamma_10==max(auc_gamma_10))}));
% title('Best fitting Gamma example')
% 
% figure;
% %subplot(1,3,3)
% eval(sprintf('hist(overall_fitness_Lognormal_10(:).%s)',fields{find(auc_lognormal_10==max(auc_lognormal_10))}));
% title('Best fitting Lognormal example')