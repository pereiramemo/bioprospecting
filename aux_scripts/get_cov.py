#!/home/epereira/anaconda3/bin/python

###############################################################################
### 1. Set env
###############################################################################

import argparse
from Bio import SeqIO
import pysam

###############################################################################
### 2. Parse input data and optional arguments
###############################################################################

parser = argparse.ArgumentParser(prog='get_abund.py', \
                                 description='Estimate BGC coverage')

parser.add_argument("--input_gbk", help="Input gbk file")
parser.add_argument("--input_bam", help="Input bam file")
parser.add_argument("--sample_name", help="Sample name")
parser.add_argument("--output_tsv", help="Output tsv file")

args = parser.parse_args()
input_gbk = args.input_gbk
input_bam = args.input_bam
sample_name = args.sample_name
output_tsv = args.output_tsv

###############################################################################
### 3. Define GBK perser function
###############################################################################

def get_features(record, feature_name, qualifier_name):
 for feature in record.features:
    if feature.type == feature_name:
       return feature.qualifiers[qualifier_name][0]

def get_feature_location(record, feature_name):
 for feature in record.features:
    if feature.type == feature_name:
       return [int(feature.location.start), int(feature.location.end)]

def gbk_parser(input_gbk):

  acc2x = dict()  
  with open(input_gbk, "r") as gbk_handle:
    for record in SeqIO.parse(gbk_handle, "genbank"):
      acc = record.annotations['accessions'][0]
      bgc_class = get_features(record,"cand_cluster", "product")
      contg_edge = get_features(record,"cand_cluster", "contig_edge")  
      location = get_feature_location(record,"cand_cluster")
      acc2x[acc] = {"acc": acc, "bgc_class": bgc_class, "contg_edge": contg_edge, "start":location[0], "end":location[1]}
      
  return(acc2x)

###############################################################################
### 4. Compute coverage function
###############################################################################

def custom_coverage(input_bam_handle, gbk_parser_out):

  coverage_dict = dict()
  seq_names = list(gbk_parser_out.keys())
  for i in seq_names:
    input_bam_cov = input_bam_handle.count_coverage(gbk_parser_out[i]["acc"], \
                                                    gbk_parser_out[i]["start"], \
                                                    gbk_parser_out[i]["end"],
                                                    quality_threshold = 0)
    n = 0
    for j in range (4):
      n += len([x for x in input_bam_cov[j] if x != 0])
    
    coverage_dict[i] = n/(gbk_parser_out[i]["end"] - gbk_parser_out[i]["start"]) 
  return(coverage_dict)

###############################################################################
### 5. Perse GBK
###############################################################################

gbk_parser_out = gbk_parser(input_gbk)
  
###############################################################################
### 6. Compute coverage
###############################################################################

input_bam_handle = pysam.AlignmentFile(input_bam, "rb")
coverage_out = custom_coverage(input_bam_handle, gbk_parser_out)
input_bam_handle.close()

###############################################################################
### 7. Format output
###############################################################################

output = dict()
for i in gbk_parser_out.keys():
  gbk_parser_out[i]["coverage"] = coverage_out[i]
  gbk_parser_out[i]["sample"] = sample_name
  output[i] = list(gbk_parser_out[i].values())

###############################################################################
### 5. Compute coverage
###############################################################################

with open(output_tsv, 'w') as f:
  [f.write('{0}\t\n'.format("\t".join(map(str,value)))) for value in output.values()]



