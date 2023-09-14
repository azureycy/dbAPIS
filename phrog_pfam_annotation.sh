#!/bash/sh

## run PHROG annotation

# download and unzip phrog db
wget https://phrogs.lmge.uca.fr/downloads_from_website/phrogs_mmseqs_db.tar.gz
tar -xzf phrogs_mmseqs_db.tar.gz
cd phrogs_mmseqs_db

# create a database with all protein fasta file
mmseqs createdb seed_prot_homolog_rmdupseq.fa prot.DB

# compute the search and convert the results into a tab separated file
mmseqs search phrogs_mmseqs_db/phrogs_profile_db prot.DB phrog_out tmp -s 7
mmseqs createtsv phrogs_mmseqs_db/phrogs_profile_db prot.DB phrog_out phrog_out.tsv

## run Pfam annotation

# download and unzip pfam db
wget https://bioconductor.org/packages/3.17/data/annotation/src/contrib/PFAM.db_3.17.0.tar.gz
tar -xzf PFAM.db_3.17.0.tar.gz

# run pfam_scan of HMMER
conda install -c bioconda pfam_scan
pfam_scan.pl -e_seq 1e-4 -e_dom 1e-2 -outfile $1.ps -fasta seed_prot_homolog_rmdupseq.fa -dir Pfam_db
