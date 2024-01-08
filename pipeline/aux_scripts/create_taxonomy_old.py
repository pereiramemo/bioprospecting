#!/usr/bin/python3

###############################################################################
### 1. Set env
###############################################################################

import argparse
import glob
import pandas as pd
import csv
from Bio import GenBank

###############################################################################
### 2. Parse input data and optional arguments
###############################################################################

parser = argparse.ArgumentParser(prog='get_taxa.py', \
                                 description='Get taxa info from GBK file')

parser.add_argument("--input_dir", help="Input dir with gbk files")
parser.add_argument("--output_tsv", help="Output tsv file")

args = parser.parse_args()
input_dir = args.input_dir
output_tsv = args.output_tsv

###############################################################################
### 3. Define GBK perser function
###############################################################################

def get_taxa(input_gbk):

  with open(input_gbk, "r") as gbk_handle:
    for record in GenBank.parse(gbk_handle):
      tax = "\t".join(record.taxonomy)
      acc = record.accession[0]
      acc2tax = [acc, tax]
      
  return(acc2tax)

###############################################################################
### 4. Get all input GBK files
###############################################################################

input_files = input_dir + "/*.gbk"
gbklist = [f for f in glob.glob(input_files)]

###############################################################################
### 5. Get all taxa info
###############################################################################

get_taxa_out_dict = dict()

for gbk_file in gbklist:
  get_taxa_out = get_taxa(gbk_file)
  if get_taxa_out[1] == "":
    get_taxa_out[1] = "NA"
  get_taxa_out_dict[get_taxa_out[0]] = get_taxa_out[1]
  
###############################################################################
### 5. Get all taxa info
###############################################################################

with open(output_tsv, 'w') as f:
  [f.write('{0}\t{1}\n'.format(key, value)) for key, value in get_taxa_out_dict.items()]


    
