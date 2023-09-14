#!/bin/bash

family_ID=$1

ls $1/*gff > gff.lst

# gff.lst is a list of genomic gff files of protein members of one family

for i in `less gff.lst`;
do
  start=$(awk 'NR==1 {print $4}' $i);
  end=$(awk 'END {print $5}' $i);
  contig=$(awk 'NR==1 {print $1}' $i);
  echo $contig:$start-$end;
done > range.txt

# example content of range.txt:
  # MH370387.1:5267-9002
  # AY052766:7664-10914
  # KY709687:12544-17486
  # MK972694:38219-41953

# if wanna assign color to the gene group by gene functions, we need a csv file containing gene function information, e.g., xxx_gf.csv
  # YP_009840590.1,ribonucleotide reductase class Ia beta subunit
  # YP_009840591.1,putative thioredoxin
  # YP_009840594.1,metal-dependent hydrolase (APIS gene)
  # YP_009840598.1,acetyltransferase

# run clinker to generate interactive gene cluster plot in html format
clinker $(cat gff.lst) -r $(cat range.txt) -p clinker_out/$1.html -o clinker_out/$1.txt -gf $1/$1_gf.csv



