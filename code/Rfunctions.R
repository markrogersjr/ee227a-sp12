## useful R functions
## by James Long
## date: April 1, 2012


## plot a single light curve
plotLightCurve = function(tfe,xLabel="Time (Days)",yLabel="m",maintitle="A Lightcurve",
                          sd.errors=1,width.error.bar=1,cex=.5,reverse=TRUE,
                          point.colors=FALSE,plot.errors=TRUE){
  if(class(point.colors) == "logical"){
    if(!point.colors){
      point.colors = 1
    }
    else {    
      point.colors = rainbow(nrow(tfe))
    }
  }
  
  tfe[,2] = -1*tfe[,2]
  # if there is no main title make the margin at the top very small
  if(maintitle == "") { par(mar=c(5.1,4.1,1,2.1)) }

  # set the width of the error bars
  xmin = min(tfe[,1])
  xmax = max(tfe[,1])
  ymin = min(tfe[,2] - sd.errors * tfe[,3])
  ymax = max(tfe[,2] + sd.errors * tfe[,3])

  # set the width of the error bar relative to x-axis
  width.error.bar = width.error.bar * (xmax - xmin) / 300
  # set up the plot to the get right dimensions
  plot(c(xmin,xmax),c(ymin,ymax),col=0,
       main=maintitle,xlab=xLabel,ylab=yLabel,yaxt='n',
       cex.lab=1)
  if(!reverse) {   axis(2) }
  else {
    yaxis = (ymax - ymin) * (0:4) / 4 + ymin
    axis(2,at=yaxis,labels=-round(yaxis,1),las=2,cex.lab=1)
  }
  ## draw the error bars
  if(plot.errors){
    segments(tfe[,1],tfe[,2] - sd.errors*tfe[,3],tfe[,1],tfe[,2] + sd.errors*tfe[,3],point.colors)
    segments(tfe[,1]-width.error.bar,tfe[,2] + sd.errors*tfe[,3],tfe[,1] + width.error.bar,tfe[,2] + sd.errors*tfe[,3],point.colors)
    segments(tfe[,1]-width.error.bar,tfe[,2] - sd.errors*tfe[,3],tfe[,1] + width.error.bar,tfe[,2] - sd.errors*tfe[,3],point.colors)
  }
  # put the points on the plot
  points(tfe[,1],tfe[,2],pch=19,cex=cex,col=point.colors)
}







###
### plots three graphs - unfolded curve, folded on 2*period, 
### and folded on period
###
DrawThreeLightCurves=function(source_to_plot,data1,time_flux,
                              smoother=TRUE,point.colors=FALSE,plot.unfolded=TRUE,
                              plot.folded=TRUE,plot.folded.twice=TRUE,par=TRUE,
                              plot.errors=TRUE){
  ## if source id is a list, grab a random l.c. to plot
  print(source_to_plot)
  number.plots = plot.unfolded + plot.folded + plot.folded.twice
  if(par){
    par(mfcol=c(number.plots,1))
  }
  tfe = subset(time_flux,
    subset=(source_id==source_to_plot),select=c("time","flux","error"))
  tfe[,1] = tfe[,1] - min(tfe[,1])
  period = 2*(1 /
    data1$freq1_harmonics_freq_0[source_to_plot == data1$source_id])
  lc.class =
    data1$classification[source_to_plot == data1$source_id]

  ## plot the raw light curve
  if(plot.unfolded){
    plotLightCurve(tfe,maintitle=as.character(lc.class),point.colors=point.colors,
                   plot.errors=plot.errors)
  }
  
  ## fold on twice estimated period
  tfe[,1] = (tfe[,1] %% period) / period
  if(plot.folded.twice){
    plotLightCurve(tfe,xLabel="Phase",maintitle=period,point.colors=point.colors,
                   plot.errors=plot.errors)
    if(smoother){
      line.smu = supsmu(tfe[,1],tfe[,2],periodic=TRUE)
      line.smu$y = -1 * line.smu$y
      lines(line.smu$x,line.smu$y,col='red',lty=1,lwd=2)
      line.smu = supsmu(tfe[,1],tfe[,2],
        span=.05,wt=1/tfe[,3],periodic=TRUE,bass=8)
      line.smu$y = -1 * line.smu$y
      lines(line.smu$x,line.smu$y,col='green',lty=1,lwd=2)
    }
  }  
  ## fold on estimated period
  tfe[,1] = (tfe[,1] %% .5) / .5
  if(plot.folded){
    plotLightCurve(tfe,xLabel="Phase",maintitle=period/2,point.colors=point.colors,
                   plot.errors=plot.errors)  
    if(smoother){
      line.smu = supsmu(tfe[,1],tfe[,2],periodic=TRUE)
      line.smu$y = -1 * line.smu$y
      lines(line.smu$x,line.smu$y,col='red',lty=1,lwd=2)
      line.smu = supsmu(tfe[,1],tfe[,2])
      line.smu$y = -1 * line.smu$y
      lines(line.smu$x,line.smu$y,col='green',lty=1,lwd=2)
    }
  }
}

