#Clear the workspace
rm(list = ls())

#Set the working directory
setwd("/mnt/6099002D98FFFF72/library/amse/master2/S2A/econometrie theorique")

#Load a useful package to generate variable lag
if (!require(dplyr)) install.packages("dplyr") 

#Load data
database= read.table("as_mod.dat",col.names = paste0("X",1:3))

#Set parameters
b0=b1=b2=b3=0
sigma = 10 #Standard deviation of the error
y1 = 0 # Initialization of y for asymptotique F-stat
B=199 #Number of bootstrap sample
N=1000 #Number of replication
y0= 1 #Initialization of y for the bootstrap
alpha = 0.05 #Confidence threshold 
sizes = seq(from=20,to=100,by=10) #Different sample sizes we will test 
#Vector to keep the p values at the end 
numbers_sizes = length(sizes)
FreqsRejectA = 1:numbers_sizes
FreqsRejectB = 1:numbers_sizes
FreqsRejectRs= 1:numbers_sizes

DGP = function(b0,b1,b2,b3,sigma,y1){
  #Initialize the result vector with the first element
  y=1:n
  y[1]=y1 
  #Generate a vector of error term
  u=rnorm(n)
  #compute successive value of y
  for (i in 2:n){
    y[i]=b0+0.6*y[i-1]+b1*X1[i]+b2*X2[i]+b3*X3[i]+sigma*u[i]
  }
  return (y)
}

DGP_B=function(b0,b1,b2,b3,y0,u){
  #Initialize y
  y=1:n
  y[1] = b0+0.6*y0+b1*X1[1]+b2*X2[1]+b3*X3[1]+u[1]
  #compute successive value of y
  for (i in 2:n){
    y[i]=b0+0.6*y[i-1]+b1*X1[i]+b2*X2[i]+b3*X3[i]+u[i]
  }
  return (y)
  
}

Fstat_B = function(b0,Yb){
  #Generate lag of Yb
  lagYb=lag(Yb,1)
  #Generate Yb diff
  diffYb=Yb - 0.6*lagYb-b0
  #concat all data for the random selection
  data= cbind(diffYb,X)
  #Select randomly n indexes with replacement
  randomRowIndex=sample(1:n,n,replace = TRUE)
  #use the generated indexes to select the observations
  data = data[randomRowIndex,]
  #make the regression 
  regb= summary(lm(diffYb~.+0,data = data))
  #return the F-stat
  fstatB = regb$fstatistic[["value"]]
  return(fstatB)
}


for (s in 1:numbers_sizes){
  
  #save the size in n
  n=sizes[s] 
  #select the first n rows of the database
  X=database[1:n,]
  attach(X)
  
  #Initialization of the vectors of the p-value
  PvaluesA = 1:N
  PvaluesB= 1:N
  PvaluesRs=1:N
  
  for (rep in 1:N){
    #Generate Y from the DGP function
    Y = DGP(b0,b1,b2,b3,sigma,y1)
    
    #Generate the lag of Y
    lagY = lag(Y,1)
    
    #Make the regression without constant of the difference on the variable
    dY=Y-0.6*lagY-b0
    reg = summary(lm( dY ~ 0+X1+X2+X3))
    
    #Get the F-stat and the estimated coefs
    fstat_as = reg$fstatistic[["value"]]
    Coefs= reg$coefficients[,"Estimate"]
    
    #Get degree of freedom
    df1 = reg$fstatistic[["numdf"]] 
    df2=reg$fstatistic[["dendf"]]
    
    #We compute the p-value and save it
    pvalue=1-pf(fstat_as,df1,df2)
    PvaluesA[rep]=pvalue
    
    #=======pre-Bootstrap=======
    #Generate the error term for the bootsrap
    u=rnorm(n,0,sigma) 
    #Generate data
    Yb = DGP_B(b0,b1,b2,b3,y0=y0,u=u)
    #Variable for saving the bootstrap p-value
    pvalueB=0
    
    #=======pre-Resampling Bootstrap====
    #re-scale the residuals of the asymptotique step
    resampRes= sqrt(n/(n-3))*(reg$residuals - mean(reg$residuals))
    #Generate data using these re-scaled residual as error term
    Yrs=DGP_B(b0,b1,b2,b3,y0=y0,u=resampRes)
    #Variable for saving the resampling bootstrap p-value
    pvalueRs=0
    
    for (b in 1:B){
      #get the F-stat bootstrap
      fstat_b = Fstat_B(b0,Yb)
      #Increment the number of extreme values if needed 
      pvalueB=pvalueB+fstat_b>fstat_as
      
      #get the F-stat for resampling bootstrap
      fstat_Rs=Fstat_B(b0,Yrs)
      #Increment the number of extreme values if needed 
      pvalueRs=pvalueRs+fstat_Rs>fstat_as
    }
    #Compute the p-value of  bootstrap and save
    pvalueB=pvalueB/B
    PvaluesB[rep]=pvalueB
    
    #Compute the p-value of  resampling bootstrap and save
    pvalueRs=pvalueRs/B
    PvaluesRs[rep]=pvalueRs
  }
  
  #Save the frequency of the rejections
  FreqsRejectA[s]= sum(PvaluesA<alpha)/N
  FreqsRejectB[s]= sum(PvaluesB<alpha)/N
  FreqsRejectRs[s]= sum(PvaluesRs<alpha)/N
  detach(X)
}

#Plot the first graph
plot(x = sizes,y=FreqsRejectA,type="l",col="blue",pch="o",lty=1,
     ylim = 0:1,xlab = "Sample size",ylab = "Rejection frequency")
#Add the second graph
points(sizes, FreqsRejectB, col="red", pch="*")
lines(sizes, FreqsRejectB, col="red",lty=2)

#Add the last graph
points(sizes, FreqsRejectRs, col="green", pch="+")
lines(sizes, FreqsRejectRs, col="green",lty=3)

#Add legend
legend(20,0.8,
       legend=c("Asymptotique","Bootstrap","Resampling Bootstrap"),
       col=c("blue","red","green"),
       pch=c("o","*","+"),lty=c(1,2,3))






