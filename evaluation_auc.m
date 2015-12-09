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

%this is to check for instances when one distribution is only margnally
%better than the other.
ind_n_mar = find(auc_nn > auc_gn & auc_nn > auc_lnn);
ind_g_mar = find(auc_gn > auc_nn & auc_gn > auc_lnn);
ind_ln_mar = find(auc_lnn > auc_nn & auc_lnn > auc_gn);

%sum of all indices for the normalized and thresholded(0.5) case
sum_length = length(ind_normal) + length(ind_gamma) + length(ind_lognormal);
%sum of all indices for the "marginally better" case
sum_length_mar = length(ind_n_mar) + length(ind_g_mar) + length(ind_ln_mar);

 
figure;
Y = [length(ind_normal) length(ind_gamma) length(ind_lognormal) (length(auc_gamma_10)-sum_length)]./length(auc_gamma_10);
explode = [1,1,1,1];
pie3(Y,explode,{'Normal 5','Gamma 0','Lognormal 6','Other 4085'});

figure; 
Y = [length(ind_n_mar) length(ind_g_mar) length(ind_ln_mar) (length(auc_gamma_10)-sum_length)]./length(auc_gamma_10);
explode = [1,1,1,1];
pie3(Y,explode,{'Normal 24%','Gamma 36%','Lognormal 38%','Other 2%'});
