### Codility exercise: BinaryGap
# Full exercise description  https://app.codility.com/programmers/lessons/1-iterations/binary_gap/ 
# Evaluation of my solution  https://app.codility.com/demo/results/trainingXHXZEN-5XU/

# Find longest sequence of zeros in binary representation of an integer.

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 12:05:12 2023
@author: tiffanyberg
"""

def my_function(N):
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
## tests
# my_function(6) ##Does not exclude trailing Zero
# my_function(328) ##Does not exclude trailing Zero
# my_function(135)
# my_function(23415)
