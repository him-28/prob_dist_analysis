function fit_ness = goodness_of_fit(X,dist,pdf)
%function to know how well a given distribution is fitting the data. We are
%using the kilgomorov-smirnov test to test this goodness of fit. 

% I plan to make multiple if-else statements for each distribution that I
% expect that can coem up as an input.This one is for Normal
%% Normal Distribution
if strcmp(dist,'Normal')
    Y = normrnd(pdf.mu,pdf.sigma,1,length(X));
    %The returned value fit_ness indicates that these two vectors Y and X
    %are the part of the same distribution at 1% significance level.
    [~,fit_ness] = kstest2(X,Y,'Alpha',0.05);

%% Gamma Distribution 
elseif strcmp(dist,'Gamma')
    if pdf.a == Inf && pdf.b == 0
        pdf.a = 9;
        pdf.b = 0.5;
    end
    Y = gamrnd(pdf.a,pdf.b,1,length(X));
    [~,fit_ness] = kstest2(X,Y,'Alpha',0.05);
%% Lognormal Distribution
elseif strcmp(dist,'Lognormal')
    Y = lognrnd(pdf.mu,pdf.sigma,1,length(X));
    [~,fit_ness] = kstest2(X,Y,'Alpha',0.05);
end

    

    
    
    