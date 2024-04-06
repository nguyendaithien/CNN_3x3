#import csv
#golden_result = csv.reader(open("../src/conv_acc_out.txt"), delimiter=',')
#my_result     = csv.reader(open("ofm_dec_c8xh61xw61.txt"), delimiter=' ')
#
#golden_vec = []
#for line in golden_result:
#    if (line == []):
#        continue
#    handle = []
#    for item in line:
#        if item != "":
#            handle.append(item)
#    golden_vec.append(handle)
#my_vec = []
#for line in my_result:
#    if (line == []):
#        continue
#    handle = []
#    for item in line:
#        if item != "":
#            handle.append(item)
#    my_vec.append(handle)
#
## for line in my_vec:
##     print line
#
#
#print ("\033[33mTesting", len(my_vec), "[ConvKernel results] ",  len(golden_vec), "[Golden results] ", "lines\033[0m")
#
#result = 0;
#for i in range(len(my_vec)):
#    if (len(my_vec[i]) != len(golden_vec[i])):
#        print (i, " ", len(my_vec[i]), " ",   len(golden_vec[i]))
#    for j in range(len(my_vec[i])):
#        if (my_vec[i][j] != golden_vec[i][j]):
#            result = 1
#            print ("\033[33mOpps! wrong result", my_vec[i][j], ", ", golden_vec[i][j],"\033[0m")
#
#if (not result):
#    print ("\033[32mPass, Correct result !!!\033[0m")
#else:
#    print ("\033[31mOpss, Wrong result !!!\033[0m")
# Compare results
import csv

# Read golden result file
golden_result = csv.reader(open("../src/conv_acc_out.txt"), delimiter=',')

# Read user's result file
my_result = csv.reader(open("ofm_dec_c8xh61xw61.txt"), delimiter=' ')

# Parse golden results
golden_vec = []
for line in golden_result:
    if line == []:
        continue
    handle = []
    for item in line:
        if item != "":
            handle.append(item)
    golden_vec.append(handle)

# Parse user's results
my_vec = []
for line in my_result:
    if line == []:
        continue
    handle = []
    for item in line:
        if item != "":
            handle.append(item)
    my_vec.append(handle)

# Compare results
for i in range(len(my_vec)):
    pass_count = 0
    for j in range(min(len(my_vec[i]), len(golden_vec[i]))):
        if my_vec[i][j] == golden_vec[i][j]:
            pass_count += 1
        else:
            print("\033[33mOpps! wrong result", my_vec[i][j], ", ", golden_vec[i][j], "\033[0m")
    print("Line", i, ": Number of passed elements:", pass_count, "/", min(len(my_vec[i]), len(golden_vec[i])))

