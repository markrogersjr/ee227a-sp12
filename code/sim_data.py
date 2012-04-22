## two classes normal, with a lot of error on 1
import numpy as np


def gen_normal_data(n1=100,n2=100,p=2):
    classification = np.concatenate((np.ones(n1,dtype="int32"),-1*np.ones(n2,dtype="int32"))).reshape((n1+n2,1))
    feat_class1 = np.random.normal(loc=0.,scale=1.,size=n1*p).reshape((n1,p))
    feat_class2 = np.random.normal(loc=1.,scale=1.,size=n2*p).reshape((n2,p))
    features = np.vstack((feat_class1,feat_class2))
    error_feature1  = np.ones(n1*p).reshape((n1+n2,1))
    error_feature2  = np.ones(n2*p).reshape((n1+n2,1)) / 10.0
    errors = np.hstack((error_feature1,error_feature2))
    everything = np.hstack((classification,features,errors))
    return everything

    

if __name__ == "__main__":
    np.savetxt("simulated_interval",gen_normal_data(n1=10,n2=10),fmt="%f")
    
