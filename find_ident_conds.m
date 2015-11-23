function inds = find_ident_conds(A,thresh)
%this is a function that returns the indices of conditions that are a part
%of repeated identical conditions. we would be using those for future
%evaluations. It takes in the array, A(considering the cond field of the
%array A), that we want to compare and the threshold saying that we want
%atleast the threshold number of repetitions in the array. This
%implementation is very specific to the data that MinSeung has collected.
%This works under the assumption that the identical conditions are
%grouped together. 

%%
inds = zeros(size(A.Cond,1),2);
i = 1 ; 
while i < size(A.Cond,1)
    %this is the place where the comparisons happen
    j = 1;
    if (i+j) < size(A.Cond,1)
        while all(A.Cond(i,:) == A.Cond((i+j),:)) && ((i+j) ~= size(A.Cond,1))
            %if (i+j) < size(A.Cond,1)
                j = j + 1;
            %end            
        end
    end
    %%
    % the statement below makes us not go to the indices which are already
    % checked in the previous iterations. Eliminates redundancy. the first
    % column of the inds matrix carries the index of the repeated vectors.
    % The second column gives the information about how many of the
    % repeated conditions are there.
    if j >= thresh
        inds(i:(i+j-1),1) = i;
        inds(i:(i+j-1),2) = j;
    end
    i = i + j;
end 
%:D 
