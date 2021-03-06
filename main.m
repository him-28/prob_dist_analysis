clear all;
%call the script to read the data
read_data;

%% playing around with different thresholds and distributions

%% Normal,10
% tic;
% [fit_ness_mat] = fit_thresh(A,'b4412',10,'Normal');
% time = toc;

%% In case we want to loop through all the genes(Lognormal Distribution(10)):
tic;
fields = fieldnames(A);
for i = 3 : numel(fields) %the first two are gene ID and conds
    [fit_ness_mat] = fit_thresh(A,fields{i},10,'Lognormal');
    % we call the overall big matrix to be a concatenation of what all it
    % contains. It is a struct which has each of the genes as one of it's
    % fields 
    eval(sprintf('overall_fitness_Lognormal_10(:).%s = fit_ness_mat',fields{i}));
end
sprintf('This program took a total of %f seconds',toc)