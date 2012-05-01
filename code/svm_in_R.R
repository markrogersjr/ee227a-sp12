####
#### get CV error rates for R svm
####
library('e1071')
library('randomForest')


## get the data
data1 = read.table("../data/CEPeasy")
datamatrix = as.matrix(data1)
p = (ncol(datamatrix)-1)/2
y = as.factor(datamatrix[,1])
x = datamatrix[,2:(p+1)]
x = x[,apply(x,2,var)!=0]

## get cv error as a function of tuning parameter
nsplits = 10
costs = 1:10
nums = (rep((1:nsplits),ceiling(nrow(x) / nsplits)))[1:nrow(x)]
cvs = sample(nums,length(nums))
results = matrix(0,nrow=length(costs),ncol=nsplits)

for(ii in 1:ncol(results)){
    trainx = x[cvs!=ii,]
    trainy = y[cvs!=ii]
    testx = x[cvs==ii,]
    testy = y[cvs==ii]
    for(jj in 1:nrow(results)){
      svm.fit.e =  svm(trainx,trainy,kernel="linear",
        cost=costs[jj])
      predictions = predict(svm.fit.e,testx)
      results[jj,ii] = mean(predictions != testy)
    }
}
mar_means = rowMeans(results)
plot(costs,mar_means)


## what does random forest do?
rf.fit = randomForest(x,y)
rf.fit
