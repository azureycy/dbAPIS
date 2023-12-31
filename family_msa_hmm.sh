#!/bin/sh

mkdir family_msa

for family_id in APIS{001..093};
do 
    # multiple sequence alignment of each family
    mafft --thread 16 --auto $family_id.fasta > family_msa/$family_id.align.faa;
    # build profile HMM for each family
    hmmbuild $family_id.hmm family_msa/$family_id.align.faa;
done
