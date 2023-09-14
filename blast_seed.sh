#!/bin/sh

# Collect virus genome sequences from INPHARED, MGV, GPD and IMG/VR
cat 1May2023_vConTACT2_proteins.faa mgv_proteins.faa IMGVR_all_proteins-high_confidence.faa GPD_proteome.faa > all_viral_duplict.faa
seqkit rmdup -s < all_viral_duplict.faa > all_viral.faa

# Search seed proteins against virus genome sequences using blastp
mkdir blast_db
makeblastdb -in all_viral.faa -dbtype prot -out blast_db/all_viral_db
blastp -query seed_pro.fasta -db blast_db/all_viral_db -out blast_seed.out -evalue 1e-10 -qcov_hsp_perc 80 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs" -num_threads 12

# extract blastp hits protein sequences and remove redundance
cut -f2 blast_seed.out | sort -u > homolog_id.lst
seqkit grep -f homolog_id.lst all_viral.faa -o homolog.fa
cat seed_pro.fasta homolog.fa > seed_prot_homolog.fa
seqkit rmdup -s < seed_prot_homolog.fa > seed_prot_homolog_rmdupseq.fa

