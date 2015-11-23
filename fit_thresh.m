function [fit_ness_mat] = fit_thresh(A,geneID,thresh,dist)
% this function tells us how well a probability distribution fit our data,
% only for those experiments when the number of idetical conditions is
% greater than a certain threshold. It takes in the data matrix, geneID
% (which is one of the fields in the structure of the data matrix), the
% threshold, and the distribution(it's name string) and spits out the
% matrix that tells us how well the function fit to our data.
%% we first get the information on the identical conditions whose number is above certain threshold.
inds  = find_ident_conds(A,thresh);
%% initializing the fit_ness amtrix to zeros. We'll start filling it up below.
fit_ness_mat = zeros(2,1);
count = 1;
%% we start traversing the array and then perform the computations on the fly.
% pdf is a struct in which each cell returns each pdffrom each of the
% cluster
i = 1 ; 
while i ~= size(inds,1) 
    if inds(i,1) ~= 0
        %we'll create a data matrix(X) now. This is the one we will use to fit
        %the distribution function
        X = getfield(A,geneID,{i:(i + inds(i,2) - 1)});
        pdf = fitdist(X,dist);
        %% write a function that returns how well the distribution fit the data
        fit_ness  = goodness_of_fit(X,dist,pdf);
        fit_ness_mat(count,1) = fit_ness;
        count = count + 1;
        %% exit the if loop and increment i by the right amount. 
        
        i = i + inds(i,2) - 1 ; 
        
    else 
        i = i + 1 ; 
    end 
end 
        
        
        
        


