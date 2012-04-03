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
library('randomForest')
library('rpart')

## get the data
point_file = '../data/convexPoint.dat'
interval_file = '../data/convexInterval.dat'
tfe = '../data/convexTfe.dat'
dataPoint = read.table(point_file,sep=';',header=TRUE)
dataInterval = read.table(interval_file,sep=';',header=TRUE)
time_flux = read.table(tfe,sep=';',header=TRUE)


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
for(i in feature_names){
  print(i)
  upper_name = paste(i,"U",sep="")
  lower_name = paste(i,"L",sep="")
  in_interval = (dataInterval[,lower_name] <= dataPoint[,i] &
                 dataInterval[,upper_name] >= dataPoint[,i])
  print(sum(in_interval))
}

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
dataPoint[,"weighted_average"] = NULL
dataPoint = na.roughfix(dataPoint)
sum(is.na(dataPoint))





## quick classification using tree based methods
rpart.fit = rpart(classification~.,data=dataPoint)
plot(rpart.fit,margin=.1)
text(rpart.fit,use.n=TRUE)


rf.fit = randomForest(classification~.,data=dataPoint)
rf.fit





## using hastie's SVM





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


