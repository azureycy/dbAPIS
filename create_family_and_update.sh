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

# generate mmseq_clustr_count.tsv
for i in `cut -f1 seed_prot_blast_all_viral.qcov_hsp_perc80.out |sort -u`;do grep $i mmseq_clustr_cov0.8/mmseq_clustr.tsv;done|cut -f1|sort -u > a
cut -f1 mmseq_clustr_cov0.8/mmseq_clustr.tsv|sort |uniq -c|sed 's/^\s*//'|awk -F" " '{print $2"\t"$1}' > mmseq_clustr_cov0.8/mmseq_clustr_count.tsv
cut -f1 mmseq_clustr_cov0.8/mmseq_clustr_count.tsv|sort -u > b
sed 's/$/\tyes/' a > aa    # label family with seed
diff a b|less|grep ">"|cut -d" " -f2|sed 's/$/\tno/' > bb
cat aa bb |sort > cc
join -t $'\t' mmseq_clustr_cov0.8/mmseq_clustr_count.tsv cc > c
sort -rnk2,2 c > mmseq_clustr_cov0.8/mmseq_clustr_count.tsv

# parse mmseq_clustr_seq.fasta to split seqs of each cluster to each single fasta file
python seq_each_clustr.py

# generate table for each family's members
for family in anti_defense_{001..089};
do for i in `grep ">" ../www/data/each_family_faa/$family.fasta|cut -d" " -f1|sed 's/>//'`;
do echo -e $family'\t'$i;done;
done > family_members.tsv
