#!/bin/sh

mkdir each_family_msa
mkdir each_family_hmm

for i in `ls each_family_faa`;
do id=${i%%.fasta*};
mafft --thread 32 --auto each_family_faa/$i > each_family_msa/$id.align.faa;
hmmbuild each_family_hmm/$id.hmm each_family_msa/$id.align.faa;
done
