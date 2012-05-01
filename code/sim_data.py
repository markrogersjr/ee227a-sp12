## two classes normal, with a lot of error on 1
## test add

## TODO:
## multivariate gaussian classes
## error bars / interpretation of error bars
##   - represent large test error through error bars
## fix plotting issue
## make loop more elegant
## code up simulated data from p 431 in hastie ("skin around an orange")

import numpy as np
import matplotlib
from matplotlib import pyplot as plt

def qda_model(means,covs,ns):
    ''' generate classification data, multivariate gaussian '''
    d, p = means.shape
    ## error check for dimensions of entries
    if covs.shape != (d,p,p):
        print "means is " + repr(d) + " x " + repr(p) + ", covs must be " + repr(d) \
            + " x " + repr(p) + " x " + repr(p)
        return 0
    if ns.shape != (d,):
        print "means is " + repr(d) + " x " + repr(p) + ", ns must be " + repr(d)
        return 0
    ## now populate the feature matrix
    features = np.ndarray((ns.sum(),p))
    jj = 0
    for ii in range(d):
        features[jj:(ns[ii] + jj),:] = \
            np.random.multivariate_normal(mean=means[ii,:],cov=covs[ii,:,:],size=ns[ii])
        jj += ns[ii]

    ## create class labels and return
    classification = np.repeat(range(ns.size),ns).reshape((ns.sum(),1))
    data = np.hstack((classification,features))
    return data

def fake_interval(means,covs,ns):
    ''' generates gaussian data and add interval of width 0.
    useful for testing interval svm code '''
    data = qda_model(means,covs,ns)
    n, p = data.shape
    intervals = np.zeros(p*n).reshape((n,p))
    data = np.hstack((data,intervals))
    return data


def unittest():
    ## qda_model
    mean = [3.0,5.0,-10.0,1.,6.]
    var = [1.3,4.0,9.0,1.,5.]
    for ii in zip(mean,var):
        means = np.array([ii[0]]).reshape((1,1))
        covs = np.array([ii[1]]).reshape((1,1))
        covs = np.array([covs])
        ns = np.array([1000])
        data = qda_model(means,covs,ns)
        print data
        print data[:,1].mean()
        assert(data[:,1].mean() > ii[0] - 4*np.sqrt(ii[1] / 1000) \
                   and data[:,1].mean() < ii[0] + 4*np.sqrt(ii[1] / 1000))


if __name__ == "__main__":
    ## test normal mixture model
    unittest()
    if 0:
        means = np.array([3.,3.,1.,1.]).reshape((2,2))
        covs = np.array([3.,1.,1.,4.]).reshape((2,2))
        covs = np.array([covs,covs])
        ns = np.array([20,30])
        data = qda_model(means,covs,ns)
        ##  plot for 2-d, 2-class case
        class1 = (data[:,0] > .5)
        class2 = (data[:,0] < .5)
        plt.scatter(data[class1,1],data[class1,2],c='blue')
        plt.scatter(data[class2,1],data[class2,2],c='orange')
        plt.show()
    ## test fake_interval
    if 0:
        means = np.array([3.,3.,1.,1.]).reshape((2,2))
        covs = np.array([3.,1.,1.,4.]).reshape((2,2))
        covs = np.array([covs,covs])
        ns = np.array([20,30])
        data = fake_interval(means,covs,ns)
        print data
    ## plot first two dimensions and color by class
    ##np.savetxt("simulated_interval",gen_normal_data(n1=50,n2=50,p=2),fmt="%f")
    
