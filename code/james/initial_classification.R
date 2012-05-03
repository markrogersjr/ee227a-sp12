## new change

########## 
########## 
########## SOME INITIAL CLASSIFICATION WORK ON LIGHTCURVES 
##########  
##########
########## by James Long 
########## date: April 1, 2012 
########## 


## program setup
rm(list=ls(all=TRUE))
set.seed(22071985)
options(width=50)

## load source files
source('Rfunctions.R')

## load packages
library('R.matlab')
library('randomForest')
library('rpart')

## get the data
data1_file = "../../data/CEPconvexMeta.dat"
point_file = '../../data/CEPconvexPoint.dat'
interval_file = '../../data/CEPconvexInterval.dat'
tfe = '../../data/CEPconvexTfe.dat'
dataPoint = read.table(point_file,sep=';',header=TRUE)
dataInterval = read.table(interval_file,sep=';',header=TRUE)
time_flux = read.table(tfe,sep=';',header=TRUE)
data1 = read.table(data1_file,sep=";",header=TRUE)


## density of points
originals = (data1$features.source_id == data1$sources.original_source_id)
sum(originals)
d1 = density(data1$features.n_points[originals])
plot(d1)


##
# 1. what kernel did joey use
# 2. set up a small/hard two class problem
# 3. figure out how kernels play in
# 4. come up with realistic simulated data set
# 5. lambda versus rho plot for loss on simulated and astro

### densities of errors
densities = aggregate(time_flux$error,by=list(time_flux$source_id),density,simplify=FALSE)
class(densities)
plot(c(.01,.06),c(0,200),col=0,xlab="Std. Dev.",ylab="Density")
j = 100
for(i in 1:j){
  if(densities[i,2][[1]]$n > 40){
    lines(densities[i,2][[1]])
  }
}

class(densities[1])
class(densities[1])

## plotting functionality
i = 0
i = i + 1



source('Rfunctions.R')


pdf(paste(i,".pdf",sep=""))
source_to_plot = dataPoint$source_id[i]
DrawThreeLightCurves(source_to_plot,dataPoint,time_flux,
                     plot.folded.twice=FALSE,
                     smoother=TRUE)
dev.off()





## check that lower bounds are always <= upper bounds
feature_names = names(dataPoint)[2:(length(dataPoint)-1)]
for(i in feature_names){
  print(i)
  upper_name = paste(i,"U",sep="")
  lower_name = paste(i,"L",sep="")
  print(sum(dataInterval[,lower_name] <=
            dataInterval[,upper_name]))
}





##
## check to see how often bounds are above / below full curve
##
dataPoint = dataPoint[order(dataPoint$source_id),]
dataInterval = dataInterval[order(dataInterval$source_id),]

## how often is feature in interval
feature_names = names(dataPoint)[2:(length(dataPoint)-1)]
frac_in_int = data.frame(rep("A",length(feature_names)),
  rep(0,length(feature_names)),stringsAsFactors=FALSE)
names(frac_in_int) = c("feature","frac_in_int")
for(j in 1:length(feature_names)){
  i = feature_names[j]
  print(i)
  upper_name = paste(i,"U",sep="")
  lower_name = paste(i,"L",sep="")
  in_interval = (dataInterval[,lower_name] <= dataPoint[,i] &
                 dataInterval[,upper_name] >= dataPoint[,i])
  print(mean(in_interval))
  frac_in_int[j,1] = i
  frac_in_int[j,2] = mean(in_interval)
}

frac_in_int[order(frac_in_int[,2],decreasing=TRUE),]



## how often is feature point above / below interval
feature_names = names(dataPoint)[2:(length(dataPoint)-1)]
for(i in feature_names){
  print(i)
  upper_name = paste(i,"U",sep="")
  lower_name = paste(i,"L",sep="")
  above_upper = dataInterval[,upper_name] < dataPoint[,i]
  below_lower = dataInterval[,lower_name] > dataPoint[,i]
  print(c(mean(below_lower),mean(above_upper)))
}




## replace missing values with medians
dataPoint[,"source_id"] = NULL
sum(is.na(dataPoint))
dataPoint = na.roughfix(dataPoint)
sum(is.na(dataPoint))





## quick classification using tree based methods
rpart.fit = rpart(classification~.,data=dataPoint)
plot(rpart.fit,margin=.1)
text(rpart.fit,use.n=TRUE)


rf.fit = randomForest(classification~.,data=dataPoint)
rf.fit
varImpPlot(rf.fit)




## using hastie's SVM
library('svmpath')
data(svmpath)




## two classes with dataPoint
## put aside 30% of the data
## fit on 70%
## test on 30%

##
cd = dataPoint$class %in% c("c","d")
temp = list()
temp$y = rep(-1,sum(cd))
temp$y[dataPoint[cd,"classification"] == "d"] = 1
features = c("std","freq1_harmonics_freq_0")
temp$x = as.matrix(dataPoint[cd,features])
train = runif(length(temp$y)) < .7
nrow(temp$x)
length(temp$y)
sum(train)
svm.fit = svmpath(temp$x[train,],temp$y[train])




####
library('svmpath')
library('e1071')

FakeData = function(n1=100,n2=100,p=10){
  y = c(rep(1,n1),rep(-1,n2))
  x = matrix(c(rnorm(n1*p,mean=1/sqrt(p)),
    rnorm(n2*p,mean=-1/sqrt(p))),ncol=p,byrow=TRUE)
  fakedata = list()
  fakedata$x = x
  fakedata$y = y
  return(fakedata)
}

n1 = 200
n2 = 200
p = 50
fakedata = FakeData(n1,n2,p)
svm.fit.path = svmpath(fakedata$x,fakedata$y,
  kernel.function=radial.kernel,param.kernel=1/p)
svm.fit.e = svm(fakedata$x,fakedata$y)

## for p=30, n1=n2=3000, algorithm fails
## Error: cannot allocate vector of size 454.5 Mb
## = 45 million doubles, but 3000^2 is 9 million
## question for siqi / mark: what is space requirement
## for path algorithm
## figure out scaling of svm and pathsvm






## if the data are not normalized, var = 1 along each dim,
## is there a problem with the margin concept
## probably yes
## in separable case, it would be very attractive to


## we are probably not scaling the input in our implementations
## yikes!

simulated = read.table("simulated_interval")
feature = 4
mean(simulated[simulated$V1 == 1,feature])
mean(simulated[simulated$V1 == -1,feature])
class1 = (simulated$V1 == 1)
plot(simulated$V2,simulated$V3,col=1*class1 + 1)
points(rnorm(10),rnorm(10),col="green")



p = (ncol(simulated) - 1)/2
summary(simulated)
y = simulated[,1]
x = simulated[,(2:(p+1))]
svm.fit = svm(x,y,kernel="linear",cost=1)
b0 = -1*svm.fit$rho
nrow(svm.fit$SV)
svm.fit$coefs
b = t(svm.fit$coefs) %*% svm.fit$SV
b
b = t(svm.fit$coefs) %*% as.matrix(x[svm.fit$index,])
c(b0,b)
summary(svm.fit)
plot(x[,1],x[,2],col=y+2)
abline(a=(-b0 / b[2]),b=(-b[1] / b[2]),col='grey')
## this should be invarient to cost





stop


################
################ testing out svm on RR lyrae data
################





## try with different svm package

## how often is interval essentially a point


#### TODO:
## 1. relation of features on full light curve to interval
##    - how often is interval essentially a point?
##      what is a good metric for measuring this?
##      what is a good graphic for showing this?
##    - what features are these most often / least often
##      true for

## 2. get a data set that is sufficiently hard

## 4. run ordinary SVM and hastie SVM on point data

## 5. write up report detailing what you did


