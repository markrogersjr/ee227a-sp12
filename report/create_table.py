#### creates tables from lists of feature weights (w) value
import os
import sys
import glob

if __name__ == "__main__":
    ### open file
    if len(sys.argv) != 2:
        print "format: create_table.py <filename>"
    try:
        f = open(sys.argv[1],'r')
    except IOError:
        print "could not open: " + sys.argv[1]
    lines = f.readlines()
    f.close()

    ### get all the file info into friendly lists
    for i in lines:
        print repr(i)
    feature_names = []
    weight = []
    for i in lines:
        j = i.split('\t\t\t\t')
        print j
        feature_names.append(j[0][:-1])
        weight.append(float(j[1][:-1]))
    print feature_names
    print weight

    ### print non-zero features in nice table
    ## beginning parts of table
    table = r"""\begin{center}\n\begin{tabular}{ | l | l |}\n\hline"""
    for j in zip(feature_names,weight):
        if j[1] > 0.0:
            table = table + r"&" + j[0] + r" & " + repr(j[1]) + r"\\" + r"\n"
    table = table +  r"""\hline\n\end{tabular}\n\end{center}"""
    print table
    output_file = sys.argv[1].split('/').pop().split('.')[0] + ".tex"
    g = open(output_file,'w')
    table = table.split('\n')
    g.writelines(table)
    g.close()