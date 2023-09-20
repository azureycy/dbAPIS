#!/bin/sh

### Generate original batch of APIS protein families ###
# run mmseqs2 for clustering
mmseqs createdb seed_prot_homolog_rmdupseq.fa mmseq_DB/mmseq_DB
mkdir mmseq_clustr_cov0.8
mmseqs cluster mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr tmp --min-seq-id 0.4 -c 0.8
mmseqs createtsv mmseq_DB/mmseq_DB mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr mmseq_clustr.tsv

# extarct sequences of clusters with >= 3 members
mmseqs createseqfiledb mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr mmseq_clustr_cov0.8/mmseq_clustr_seq --min-sequences 3
mmseqs result2flat mmseq_DB/mmseq_DB mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr_seq mmseq_clustr_cov0.8/mmseq_clustr_seq.fasta

### Add newly curated APIS proteins ###
# compare new APIS proteins with existing APIS families using mmseqs search
mmseqs createdb newlycurated_prot_homolog_rmdupseq.fa newlycurated_prot_homolog_rmdupseq_DB
mmseqs search newlycurated_prot_homolog_rmdupseq_DB ../mmseq_DB newlycurated_outDB tmp --min-seq-id 0.4 -c 0.8
mmseqs convertalis newlycurated_prot_homolog_rmdupseq_DB ../mmseq_DB newlycurated_outDB newlycurated_outDB.tsv

# if hits on <70% of members a family, then mmseqs cluster to form new family_members
mmseqs cluster newlycurated_prot_homolog_rmdupseq_DB new_clustering tmp --min-seq-id 0.4 -c 0.8
mmseqs createtsv newlycurated_prot_homolog_rmdupseq_DB newlycurated_prot_homolog_rmdupseq_DB new_clustering new_clustr.tsv
