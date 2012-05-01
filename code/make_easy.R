########## 
########## 
########## CONVERT INTERVAL DATA INTO EASY FORM 
##########  
##########
########## by James Long 
########## date: April 29, 2012 
########## 


convert_to_easy_format = function(input,output){
  dataInterval = read.table(input,sep=';',header=TRUE)
  nrow(dataInterval)
  feat_names = names(dataInterval)[1:(length(dataInterval)-2)]
  feat_names = substr(feat_names,1,nchar(feat_names)-1)
  feat_names = unique(feat_names)
  nrow(feat_names)
  classification = rep(1,nrow(dataInterval))
  class2 = levels(dataInterval$classification)[2]
  classification[dataInterval$classification==class2] = -1


  ## construct data matrix to output
  datamatrix = matrix(0,nrow=nrow(dataInterval),
    ncol=2*length(feat_names)+1)
  datamatrix[,1] = classification
  cnames = names(dataInterval)
  cnames = substr(cnames,1,nchar(cnames)-1)
  for(i in 1:length(feat_names)){
    temp = dataInterval[,cnames %in% feat_names[i]]
    center = rowSums(temp) / 2
    width = abs(temp[,1] - temp[,2]) / 2
    datamatrix[,(i+1)] = center
    datamatrix[,(length(feat_names)+i+1)] = width
  }
  head(datamatrix)
  write.table(datamatrix,file=output,row.names=FALSE,
              col.names=FALSE)
}



