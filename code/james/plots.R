########## 
########## 
########## PLOTS FOR FINAL REPORT 
##########  
##########
########## by James Long 
########## date:  May 1, 2012
########## 






#####
##### show that RR lyrae periods are sometimes wrong
#####


## load packages
data1_file = "../data/CEPconvexMeta.dat"
point_file = '../data/CEPconvexPoint.dat'
interval_file = '../data/CEPconvexInterval.dat'
tfe = '../data/CEPconvexTfe.dat'
dataPoint = read.table(point_file,sep=';',header=TRUE)
dataInterval = read.table(interval_file,sep=';',header=TRUE)
time_flux = read.table(tfe,sep=';',header=TRUE)
data1 = read.table(data1_file,sep=";",header=TRUE)

ordering = sample(1:nrow(dataPoint),nrow(dataPoint))
dataPoint = dataPoint[ordering,]

int_classes = rep(1,nrow(dataPoint))
int_classes[dataPoint$classification==levels(dataPoint$classification)[2]] = 2
coloring = c("orange","blue")
pchs = c(1,2)

pdf('../report/period_amplitude.pdf')
plot(log(dataPoint$amplitude,base=10),
     log(1/dataPoint$freq1_harmonics_freq_0,base=10),
     col=coloring[int_classes],
     pch=pchs[int_classes],
     lwd=2,
     xlab="log(amplitude)",
     ylab="log(period)",
     main="Period-Amplitude Relationship for Two Star Classes")
rect(-1,0,0,2,border="green",lwd=2)
legend("topleft",levels(dataPoint$classification),
       col=coloring,pch=pchs,lwd=2)
dev.off()
## 2 > log(period) > 0
## 0 > log(amplidue) > -1



source('Rfunctions.R')


pdf(paste(i,".pdf",sep=""))
source_to_plot = dataPoint$source_id[i]
DrawThreeLightCurves(source_to_plot,dataPoint,time_flux,
                     plot.folded.twice=FALSE,
                     smoother=TRUE)
dev.off()




meanfreq =  (dataInterval$freq1_harmonics_freq_0U + dataInterval$freq1_harmonics_freq_0L) / 2
meanamp = (dataInterval$amplitudeU + dataInterval$amplitudeL)/2
meanamp
plot(log(meanamp,base=10),log(1/meanfreq,base=10),
     col=dataInterval$classification)
segments(log(meanamp,base=10),log(1/dataInterval$freq1_harmonics_freq_0L,base=10),log(meanamp,base=10),log(1/dataInterval$freq1_harmonics_freq_0U,base=10),col='grey')
## color points as to size of error bars
## most of the objects outside of the box have intervals inside
## most of the objects inside the box have intervals contained
## within the box
