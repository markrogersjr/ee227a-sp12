########## 
########## 
########## SOME INITIAL CLASSIFICATION WORK ON LIGHTCURVES 
##########  
##########
########## by James Long 
########## date: April 1, 2012 
########## 


#### TODO:
## 1. relation of features on full light curve to interval
##    - how often is full light curve feature in interval?
##    - how often is interval essentially a point?
##    - what features are these most often / least often
##      true for

## 2. move plotting functions into this folder

## 3. run cart and RF on point data

## 4. run ordinary SVM and hastie SVM on point data

## 5. write up report detailing what you did


## program setup
rm(list=ls(all=TRUE))
set.seed(22071985)
options(width=50)

## load source files
source('Rfunctions.R')

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
source_to_plot = dataPoint$source_id[i]
DrawThreeLightCurves(source_to_plot,dataPoint,time_flux)






## check to see how often bounds are above / below full curve
dataPoint = dataPoint[order(dataPoint$source_id),]
dataInterval = dataInterval[order(dataInterval$source_id),]

features = (grepl('U',names(dataInterval)) | grepl('L',names(dataInterval))) 
dataInterval.features = dataInterval[,features]

sum(dataInterval$flux_percentile_ratio_mid50L < dataInterval$flux_percentile_ratio_mid50U)


sum(dataPoint$flux_percentile_ratio_mid50 < dataInterval$flux_percentile_ratio_mid50U)





nrow(dataInterval)
