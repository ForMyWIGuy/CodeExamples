#CSCI 3003/5465 Midterm 1, Fall 2022


# Problem 1
mystring = "1,-10,3,NA,-1,2,5"

#a.	(3 pts) Print the first 6 characters of the string.
print(mystring[0:6])

#b.	(3 pts) Print the last 2 characters of the string.
print(mystring[-2::])

#c.	(2 pts) Print the length of the string.
print(len(mystring))

#d.	(3 pts) Count and print the number of commas appearing in the string.
count = 0
for char in mystring:
    if char == ",":
        count += 1
print(count)

#e.	(3 pts) Create a list called result that consists of the individual, comma-delimited fields contained within this string. 
#   The value in result should be ["1","-10","3","NA","-1","2","5"] after your code runs.
result = []
result = mystring.split(",")
print(result)

#f.	(2 pts) Access first element of result, convert it to an integer, and store the result in intresult.
#Note: for all questions above, your code must work even if we were to redefine the initial string with a different value.
intresult = int(result[0])
print(intresult)

# Problem 2
ilist = [-3,0,4,-1,5,2] 

#Write code that will:
#a.	(3 pts) Access and print the 4th element of the list (the -1).
print(ilist[3])

#b.	(4 pts) Print all elements of the loop to the screen, one element per line.
for item in ilist:
    print(item)
    
#c.	(3 pts) Create a new list, called list2, that contains only the positive elements (> 0) of ilist. 
list2 = []
for element in ilist:
    if element > 0:
        list2.append(element)
print(list2)

#d.	(4 pts) Create a new list, called ilist_sorted, that contains a sorted version of ilist (elements in ascending order). Your code should not change the value in ilist.
ilist_sorted = ilist.copy()
ilist_sorted.sort()
print(ilist, ilist_sorted)

#e.	(3 pts) Create a new list, called list3, that contains all but the last two elements of ilist.
#Note: for all questions above, your code must work even if we were to redefine the initial list with different values.
list3 = []
for i in range(len(ilist)-2):
    list3.append(ilist[i])
print(list3)

# Problem 3
alpha = 'ABCDEFGHIJKLMNOPABCD'
letterdictionary = {}

count = 15
for curr in alpha:
	letterdictionary[curr] = count
	count -= 1


#Write code that will:
#a.	(3 pts) Print the number of key-value pairs contained in letterdictionary.
print(len(letterdictionary))

#b.	(2 pts) Add a key-value pair to letterdictionary with key: 'Z' and value 26.
letterdictionary['Z'] = 26

#c.	(4 pts) Modify the value associated with every key in the dictionary to subtract 10 from its current value. 
for key,value in letterdictionary.items():
    letterdictionary[key] = letterdictionary[key] - 10
print(letterdictionary)

#d.	(4 pts) Print all key-value pairs in tab-delimited format (one key-value pair per line).
for key,value in letterdictionary.items():
    print(key,value,sep='\t')

#e.	(4 pts) Create a new dictionary called modletters that contains only the key-value pairs from letterdictionary 
# for which the value is positive (>0).
modletters = {}
for key,value in letterdictionary.items():
    if letterdictionary[key] > 0:
        modletters[key] = value

print(modletters)

# Problem 4
#Write a Python script that does the following:
#(a) (10 pts) Open the input sequence file and load the SARS-CoV2 sequence into a variable called sars_sequence.

with open("MN3_MDH3_2020_SARS_CoV2.fasta", "r") as sars_covid_file:
    header_line = sars_covid_file.readline()
    header_line = header_line.lstrip('>').rstrip()
    sars_sequence = ''
    for line in sars_covid_file:
        line = line.rstrip()
        sars_sequence += line

#(b) (3 pts) Print the total length of the sequence. (Note: this should exclude any formatting characters)
# I checked for any formatting characters remaining and there were none, commented out code: 
# for curr in sars_sequence:
#     if curr == 'A' or curr == 'T' or curr == 'C' or curr == 'G':
#         continue
#     elif curr == '\t' or curr == '\n':
#         print(curr)
#     else:
#         print(curr)

print(len(sars_sequence))


#(c) (5 pts) Extract the nucleotide sequence corresponding to the spike protein and store this in a variable called spike_sequence.  
#     The spike protein sequence starts with (and includes) the sequence ATGTTTGTT and ends with (and includes) TACACATAA.
spike_sequence = ''
start = 'ATGTTTGTT'
stop = 'TACACATAA'
include_in_stop = len(stop)

# start_index = set()
# stop_index = set()

for seq in sars_sequence:
    start_index = (sars_sequence.find(start))
    begin_stop_index = sars_sequence.find(stop)
    stop_index = begin_stop_index + include_in_stop
    
for nucleotide in range(len(sars_sequence[start_index:stop_index])):
    spike_sequence += sars_sequence[nucleotide]
    
# print(spike_sequence)
    

#(d) (5 pts) Create a new variable called spike_rnasequence, which contains the corresponding RNA sequence. Remember that to 
#    convert a DNA sequence into RNA, you’ll need to replace the thymines (T’s) with uracils (U’s).
spike_rnasequence = ''       
spike_rnasequence = spike_sequence.replace('T','U')

# print(spike_rnasequence[0:20])
# print(spike_sequence[0:20])

#(e) (10 pts) Compute the frequency of all codons present in the spike protein’s RNA sequence. In other words, 
#    compute the number of occurrences of all unique 3 base-pair sequences assuming the frame starting at the beginning 
#    sequence provided in (c). In order to get full credit for this solution, your code must use a dictionary.
######## This is where I losst points --- See midterm1.py for what I learned Lecture 13 he walked through the solutions  ####

rna_dict = {}
for i in range(len(spike_rnasequence)-3):
    codon = spike_rnasequence[(i):(i+3):1]
    # print(codon)
    if codon in rna_dict:
        rna_dict[codon] += 1
    else:
        rna_dict[codon] = 1
    
# print(rna_dict)

#(f) (6 pts) Print out the frequency of all codons that appear at least once in the sequence in the following 
#    format (one codon per line):
#AUG: 14
#UUU: 59
#...
#Report the frequency as an absolute count (# of occurrences of each codon in the spike protein sequence). 
#  You may print the codons in any order as long as the frequencies are correct and you follow the format above.

for key,value in rna_dict.items():
    print(key,": ",value, sep='')

#(g) (5 pts) The 4 codons for the amino acid alanine are GCU, GCC, GCA, and GCG. Create two parallel lists, 
#    one called A_codons that contains strings with these four codons (GCU, GCC, GCA, GCG) and a second list called 
#    A_codons_freq that contains the frequencies of these codons in the same order. Both lists should have four elements.

A_codons = ['GCU', 'GCC', 'GCA', 'GCG']
A_codons_freq = [rna_dict['GCU'], rna_dict['GCC'], rna_dict['GCA'], rna_dict['GCG']]

        
#(h) (3 pts) Use the lists from (g) to compute the maximum frequency alanine codon. Print the codon sequence and the number 
#    of occurrences to the screen.
max_freq = max(A_codons_freq)
# for indexed_location,freq in enumerate(A_codons):
indexed_location = A_codons_freq.index(max_freq)
print(A_codons[indexed_location], max_freq)


#(i) (3 pts) Use the lists from (g) to compute the minimum frequency alanine codon. Print the codon sequence and the number 
#    of occurrences to the screen.
min_freq = min(A_codons_freq)
index_min = A_codons_freq.index(min_freq)
print(A_codons[index_min], min_freq)

#NOTE: for all parts of this problem, to get full credit, your code should be written such that if we were to change 
#    the input sequence file, your code would produce the correct output for any input SARS CoV2 sequence.
