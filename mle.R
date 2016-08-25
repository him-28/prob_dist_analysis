# MLE function creation from http://www.r-bloggers.com/fitting-a-model-by-maximum-likelihood/

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
    # if we want to use the results from this mleFit object, we can do something like the following:
    coefficients = coef(mleFit)
    
    mu_mle[j, i] = coefficients[1]
    sig_mle[j, i] = coefficients[2]
    t_mle[j, i] = mu_mle[j,i]/ sqrt(sig_mle[j,i]/n)
      
  }  
}
