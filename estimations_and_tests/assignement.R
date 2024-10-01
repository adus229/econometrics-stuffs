setwd("/mnt/6099002D98FFFF72/library/amse/master2/S2A/econometrie theorique/midterm2")

#Load data
data = read.table("as2.dat",col.names =c("Y","X1","X2"))

Y = data$Y
X=data[,2:3]


#Make logistic regression
reg.logit = summary(glm(Y~.,data=data,family = "binomial"))
reg.logit

F = function(beta,X=X){
  #create the matrix X in the form of (1,x1,x2)
  input_matrix = as.matrix(cbind(rep(1,nrow(data)),X)) 
  #return the logistic value
  return(1/(1+ exp(-( input_matrix %*% beta))))
}

#the negative likelihood function
likelihood = function(beta,Y=Y,X=X){
  #compute Ft
  func= F(beta,X)
  #Return the negative likelihood
  return (-sum(Y*log(func)+(1-Y)*log(1-func)))
}


#Result of the optimization
results = optim(par = c(1,1,1),
               fn = likelihood,Y=Y,X=X,
               method ="BFGS",
               control = list(maxit=1000),
               hessian = TRUE)
#print the results
print(results)

#compute the std
stds = sqrt(diag(solve(results$hessian)))

#Compute the t-student only for the 2 first coefficients
students = (results$par[2:3] - c(3,4))/stds[2:3]
#Compute the pvalues
pvalues = pt(students,99)
#print
pvalues



#LR test

# For the hypothesis beta_1 = 3
#get the likelihood under the alternative hypothesis 
l1=-results$value 

#Change the coef of x_1 to 3
params1 = results$par
params1[2]= 3
#compute the likelihood under the null hypothesis
l01=-likelihood(params1,Y,X)
#Compute the LR stat and the corresponding p-value 
LR1 = 2*(l1-l01)
pvalue1 = pchisq(LR1,1)
pvalue1


## For the hypothesis beta_1 = 3
params2 = results$par
params2[3]= 4
l02=-likelihood(params2,Y,X)
LR2 = 2*(l1-l02)
pvalue2 = pchisq(LR2,1)
pvalue2


#Summarise results
summary_coefs = round(cbind(reg.logit$coefficients[2:3,1],results$par[2:3]),2)
summary_test = round(cbind(c(pvalues),c(pvalue1,pvalue2)),2)
summary=rbind(c("----","----"),summary_coefs,c("----","----"),c("t-stat","LR-stat"),summary_test)
row.names(summary) = c("Coefs","beta_1","beta_2","----","Pvalue","beta_1","beta_2")
colnames(summary) = c("Logit","MLE")
summary
