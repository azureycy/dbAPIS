# run mmseqs2 on GLU
mmseqs createdb seed_prot_homolog_rmdupseq.fa mmseq_DB/mmseq_DB

mkdir mmseq_clustr_cov0.8
mmseqs cluster mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr tmp --min-seq-id 0.4 -c 0.8
mmseqs createtsv mmseq_DB/mmseq_DB mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr mmseq_clustr.tsv

mmseqs createseqfiledb mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr mmseq_clustr_cov0.8/mmseq_clustr_seq --min-sequences 3
mmseqs result2flat mmseq_DB/mmseq_DB mmseq_DB/mmseq_DB mmseq_clustr_cov0.8/mmseq_clustr_seq mmseq_clustr_cov0.8/mmseq_clustr_seq.fasta

# add newly curated APIS protein to existing fmailies
mmseqs createdb 4_newlycurated_prot_homolog_rmdupseq.fa 4_newlycurated_prot_homolog_rmdupseq_DB
mmseqs search 4_newlycurated_prot_homolog_rmdupseq_DB ../mmseq_DB newlycurated_outDB tmp --min-seq-id 0.4 -c 0.8
mmseqs convertalis 4_newlycurated_prot_homolog_rmdupseq_DB ../mmseq_DB newlycurated_outDB newlycurated_outDB.tsv

diamond makedb --in ../seed_prot_homolog_rmdupseq.fa -d diamondDB_seed_prot_homolog_rmdupseq
diamond blastp -d diamondDB_seed_prot_homolog_rmdupseq -q 4_newlycurated_prot_homolog_rmdupseq.fa -o newlycurated_diamond.out --threads 16 -e 1e-10 --id 0.8

# if not hits in mmseqs search/blastp output, then mmseqs cluster to form new family_members
mmseqs cluster 4_newlycurated_prot_homolog_rmdupseq_DB 4_new_clustering tmp --min-seq-id 0.4 -c 0.8
mmseqs createtsv 4_newlycurated_prot_homolog_rmdupseq_DB 4_newlycurated_prot_homolog_rmdupseq_DB 4_new_clustering 4_new_clustr.tsv
