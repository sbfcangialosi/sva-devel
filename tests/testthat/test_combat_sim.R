library(sva)
library(testthat)
context("ComBat test on simulated data")


### Run ComBat on a simple simulated dataset
test_that("check ComBat output with several different parameters on simulated genes",{
# generate simulated data 
 nb <- 3  # number of batches
 nw <- 5  # samples within batch
 n <- nw*nb # total number of sampes
 batch <- rep(1:nb, each = nw) # batch variable for ComBat
 set.seed(0)
 treat <- rbinom(n,1,c(.5,.5)) # treatment variable--generated at random 
 beta <- 1:(nb+1) # batch effects + treatment effect (last one)
 X <- model.matrix(~-1+as.factor(batch)+treat)
 genes <- 100
 set.seed(0)
 y <- matrix(rnorm(n*genes,X%*%beta),nrow=genes, byrow=TRUE) # generate data

 ### Test ComBat with different parameters:
 # without covariates 
 batch_only <- ComBat(y,batch)
 gene1_batch_only <- c(6.5275687,1.9434116,3.3016615,6.5353399,5.8317968,-0.3314552,3.9485709,4.5368716,4.8050618,7.0422784,4.2176928,2.6528653,2.3037212,7.1688336,3.1533711)
 expect_equal(as.numeric(batch_only[1,]),gene1_batch_only)
 
 # without covariates non-parametric
 batch_only_non <- ComBat(y,batch,par.prior=FALSE)
 gene1_batch_only_non <- c(6.5041159,1.9798940,3.3203856,6.5117856,5.8174409,-0.2101846,3.9735703,4.5486383,4.8107961,6.9976908,4.1925793,2.6502177,2.3060862,7.1013511,3.1435378)
 expect_equal(as.numeric(batch_only_non[1,]),gene1_batch_only_non)
 
 # with covariates 
 batch_treat <- ComBat(y,batch,treat,par.prior=TRUE)
 gene1_batch_treat <- c(6.9550540,1.3750580,3.0128757,6.9644248,6.1160719,0.8808531,5.5188802,6.0339045,6.2686899,8.2272474,2.8499106,1.3062056,0.9617743,5.8187037,1.7999553)
 expect_equal(as.numeric(batch_treat[1,]),gene1_batch_treat)

 # with covariates non-parametric
 batch_treat_non <- ComBat(y,batch,treat,par.prior=FALSE)
 gene1_batch_treat_non <- c(6.9621810,1.4557761, 2.9477604, 6.9707174, 6.1979029, 0.9018672, 5.5466543, 6.0315322, 6.2525748, 8.0964907, 2.7563817, 1.3122575, 0.9900446, 5.8403030, 1.7741566)
 expect_equal(as.numeric(batch_treat_non[1,]),gene1_batch_treat_non)
 
 # with covariates missing data
 ## introduce missing values 10%
 set.seed(1)
 m <-  matrix(rbinom(n*genes,1,.9),nrow=genes, byrow=TRUE)
 ymis <- y
 ymis[m==0] <- NA
 batch_treat_mis <- ComBat(ymis,batch,treat)
 gene1_batch_treat_mis <- c(7.0249052, 1.4302766, 3.0979753, NA, 6.1706164, 0.7848869, NA, 5.9650280, 6.2100799, 8.2542787, 2.8907924, 1.3319739, 0.9841704, 5.8422657, 1.8305576)
 expect_equal(as.numeric(batch_treat_mis[1,]),gene1_batch_treat_mis)
 
})

 
 

