#!/home/epereira/anaconda3/bin/python

###############################################################################
### 1. Set env
###############################################################################

import argparse
import os

###############################################################################
### 2. Parse input data and optional arguments
###############################################################################

parser = argparse.ArgumentParser(prog='create_taxonomy.py', \
                                 description='Estimate BGC coverage')

parser.add_argument("--input_tsv", help="Input tsv taxonomy annotation file")
parser.add_argument("--output_dir", help="Output dir")

args = parser.parse_args()
input_tsv = args.input_tsv
output_dir = args.output_dir

###############################################################################
### 3. Create outut dir
###############################################################################

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

###############################################################################
### 4. Parse taxa annotation file
###############################################################################

with open(input_tsv, 'r') as input_tsv_handler:
  
  input_tsv_lines = input_tsv_handler.readlines()
  
  for line in input_tsv_lines:
    line_list = line.strip().split("\t")
    sample = line_list[0].split("__")[0]
    seq_id = line_list[0]
    path = "\t".join(line_list[8].split(";")[1:]) 
    output_line = "\t".join([seq_id, path])
    
    sample = "_".join([sample,"taxonomy.tsv"])
    output_file = "/".join([output_dir,sample])
    
    with open(output_file, 'a') as output_file_handler:
      print(output_line, file = output_file_handler)
    