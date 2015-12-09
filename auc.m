function auc = auc(vector)
%this function returns a scalar value that tells us the area under the
%curve for the following curve made from the input vector : we have the
%number of values in vector that are greater than a threshold v/s the
%threshold. The assumption is that all values in vector lie between 0 and
%1.

% the threshold is on the X axis. We have broken it into the intervals of
% 0.1.
X = 0:0.1:1 ;
Y = zeros(size(X));
for i = 1 : length(X)
    Y(i) = length(find(vector > X(i)));
end 

% since we have both X and Y, we now have the curve. We can plot it too if
% needed. But our main focus is the area under the curve. 

auc = trapz(X,Y);
end