#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  5 16:15:30 2022

@author: tiffanyberg
"""
# Open the sequence file in read mode.
file_name = "SequenceX.fasta"
seqxFile = open(file_name, "r")

sequence=''
seqx_info = seqxFile.readline().strip()

for line in seqxFile:
    sequence += line.strip()

start = sequence.find("TATAAA")
start = start + 10
stop = sequence[488:].find("TAT")
stop_1 = sequence[488:].find("TAG")
stop_2 = sequence[488:].find("TGA")

post_protein_seg = sequence[488:]
stop = post_protein_seg.find("TGA")
stop1 = post_protein_seg.find("TAG")
stop2 = post_protein_seg.find("TAT")
final_stop = min(stop,stop1,stop2)
protein_coding_region = post_protein_seg[:95]

protein_seq_RNA = protein_coding_region.replace("T", "U")

with open("DNA_output.fasta", "w") as my_outfile_DNA:
    print("DNA Sample name:", protein_coding_region, sep='\n', file=my_outfile_DNA)


with open("RNA_output.fasta", "w") as my_outfile_RNA:
    print("RNA Sample: ", protein_seq_RNA, sep='\n', file=my_outfile_RNA)
 
        
