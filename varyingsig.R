# p = number of genes
# n = number of samples
# c = number of conditions 

# --------------------------------------------

# function to generate synthetic data 
gen_data <- function(n,c,p,sig) {
  data = matrix(, n*c, p)
  # n, c and p are the number of replicates per gene-condition pair, number of conditions and number of genes respectively. 
  
  # Like in the reference paper, I have designed this data to have the last gene as the most 'up regulated'. In order to do that, 
  # I have a mean of zero for all of them except the last gene. 
  
  for (j in 1:c) {
    # creating a vector of means and variances :
    # mu is a vector containing the true means of the distribution which will be used to create the replicates for each gene condition pair  
    mu = vector(, p)
    #initlializing only the last element of mu as something other than zero 
    #I'm having 5% of the genes as up reglated. 
    left = p - round(0.02*p) + 1
    right = p
    mu[left:right] = 0.7
    
    sigma = vector(, p)
    
    #some common variance value for all genes
    sigma[1:p] = sig
    
    #for (i in 1:p) {
    #  sigma[i] = runif(1, 0.1, 2.5)
    #}
    
    for (i in 1:p) {
      row1 = (j-1)*n + 1
      row2 = j*n
      data[row1:row2, i] = rnorm(n, mean = mu[i], sd = sigma[i])
    }
  }
  
  
  # #   # transforming the data matrix such that it only contains positive numbers and ones scaled from 0 to 1
  #   nrows = dim(data)[1]
  #   ncols = dim(data)[2]
  #   
  #   for (i in 1 : nrows) {
  #     for (j in 1 : ncols) {
  #       if (data[i,j] < 0) {
  #         data[i,j] = -1*data[i,j]
  #       } 
  #       
  #       if (data[i,j] >= 1) {
  #         data[i,j] = 1/data[i,j]
  #       }
  #     }
  #   }
  
  return(data)
}




# ----------------------------------------------

# function for generating the matrix of t statistics from 'data' using MLE

mle_t <- function(data, n, c, p) {
  
  # the inputs are the following in the same order as mentioned:
  # data = the data matrix
  # n = number of replicates for each gene condition pair
  # c = number of conditions
  # p = number of genes
  
  mu_mle = matrix(, c, p)
  sig_mle = matrix(, c, p)
  t_mle = matrix(, c, p)
  
  for (i in 1 : p) {
    for (j in 1 : c) {
      
      row1 = (j-1)*n + 1
      row2 = j*n
      x = data[row1 : row2, i]
      LogLikelihood <- function (mu, sigma) { 
        R = suppressWarnings(dnorm(x, mu, sigma)) 
        #
        -sum(log(R))
      }
      library(stats4)
      mleFit = mle(LogLikelihood, start = list(mu = 0, sigma=1))
      # if we want to use the results from this mleFit objec t, we can do something like the following:
      coefficients = coef(mleFit)
      
      mu_mle[j, i] = coefficients[1]
      sig_mle[j, i] = coefficients[2]
      t_mle[j, i] = mu_mle[j,i]/ sqrt(sig_mle[j,i]/n)
      
    }  
  }
  
  return(t_mle)
}

# ----------------------------------------------

#function for MVR and generating t statistics from it.

mvr_t <- function (data_mvr, n, c, p) { 
  
  t_mvr = mle_t(data_mvr, n, c, p)
  return(t_mvr)
  
}

# ----------------------------------------------


# main function: including cross validation for performance evaluation through the two metrics
cv_mle = c()
cv_mvr = c()
for (k in seq(from = 0.1, to = 1, by = 0.1)) {
  n = 5
  c = 1
  p = 1000
  sig = k
  data = gen_data(n,c,p,sig)
  
  cv_acc_mle = 0
  for (i in 1:n) {
    rows_to_remove = c() 
    for (j in 1:c) {
      row = (j-1) + i
      rows_to_remove = append(rows_to_remove, row)
    }
    data_new = data[-c(rows_to_remove), ]
    t_new = mle_t(data_new, n-1, c, p)
    
    if (which.max(t_new) >= round(0.98*p)) {
      cv_acc_mle = cv_acc_mle + 1/n
    }
  }
  cv_mle = append(cv_mle, cv_acc_mle)
  
  
  library("MVR")
  data_modified = mvr(data, block = rep(1,nrow(data)), tolog = FALSE, nc.min = 1, nc.max = 1, probs = seq(0, 1, 0.01), B = 100, parallel = FALSE, conf = NULL, verbose = TRUE)
  data_mvr = data_modified$Xmvr
  
  cv_acc_mvr = 0
  for (i in 1:n) {
    rows_to_remove = c() 
    for (j in 1:c) {
      row = (j-1) + i
      rows_to_remove = append(rows_to_remove, row)
    }
    data_new = data_mvr[-c(rows_to_remove), ]
    t_new = mvr_t(data_new, n-1, c, p)
    
    if (which.max(t_new) >= round(0.98*p)) {
      cv_acc_mvr = cv_acc_mvr + 1/n
    }
  }
  cv_mvr = append(cv_mvr, cv_acc_mvr)
}

# plotting
plot(cv_mle, type = "o", col = "blue", xlab = "Sigma(*10)", ylab = "MLE vs MVR performance using CV")
lines(cv_mvr, type = "o", col = "red")
legend('bottomright', c("MLE cv performance","MVR cv performance"), lty=c(1,1), bty='n', lwd=c(2.5,2.5),col=c("blue","red"))