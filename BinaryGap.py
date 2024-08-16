#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 12:05:12 2023

@author: tiffanyberg
"""

def my_function(N):
    
    # N = input("Provide a number\n")
    # n = int(6)
    # bin_n = bin(n)
    # bin_n = bin_n[2:]
    
    # print(n, bin_n)
    # len(bin_n)
    # sub1 = '1'
    # one_count = bin_n.count('1')
    # if one_count >= 2:
    #     a = bin_n.split(sub1)
    #     # a[1]
    # #else:
    #     #print('0')
    #     #return(0)
        
    # # A = []
    # current_max_count = 0
    # for item in a:
    #     # print(item)
    #     current_count_new = item.count('0')
    #     if current_count_new > current_max_count:
    #         current_max_count = current_count_new
    # print("Final Answer:", current_max_count)
    # #return(current_max_count)
        
        
    #     if item.isdigit() == True:
    #         A.append(item)
        
    # # len(A)
    # for each in bin_n:
    #     if bin_n[each] == 1:
    #         print("Hello")
    
    #### Effective 100% correct answer begins here
    B = []    
    binary_gap = 0
    my_num = str(bin(N)[2:])
    
    for item in my_num:
        B.append(item)
    
    index = []

    for iterator in range(len(B)):
        if (B[iterator] == '1'):
            index.append(iterator)
    
    max_difference = 0    
    
    for num in range(1, len(index)):
        value1 = index[num]
        prior_val = num-1
        value2 = index[prior_val]
        current_difference = value1 - value2
        if current_difference > max_difference:
            max_difference = current_difference
    
    if max_difference == 0:
        return(0)
    
    else:
        binary_gap = max_difference - 1
        return(binary_gap)

my_function(6) ##Does not exclude trailing Zero
my_function(328) ##Does not exclude trailing Zero
my_function(135)
my_function(23415)
