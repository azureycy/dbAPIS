#!/bin/sh

for family_id in APIS{001..093};
do 
    mafft --thread 16 --auto $family_id.fasta > $family_id.align.faa;
    hmmbuild $family_id.hmm $family_id.align.faa;
done
