# 11/19/2024 (by Yuchen Yan)
This new release contians 43 verified seeds + 5605 homologs. 27 of them are assigned to previous families.
The rest 5621 new seqs were concatenated with 124 (including 3 single seeds) unclassified seqs from the last update for new clustering (5621+124=5745 seqs).
This clustering generates 107 families (members >=3) with 5451 seqs. 294 of 5745 seqs didn’t form families, noted as unclassified.
More importantly, 36 of 43 seeds are clustered into families, while 7 of 43 are unclassified. Interestingly, there are three seeds in the same family APIS136.

In total, we now have 199 APIS families and 84 verified seeds, 10 of 84 are singletons.
The previous clan classification was discarded, all families were re-classified into 73 new clans.

Two new metadata files provided:
- seed_and_familyrep_all_infor.tsv
        All information for seed proteins and family representative proteins.
- family_member_infor.tsv
        family member mapping table with metadata information.

# 09/19/2023 update (by Yuchen Yan)
Added 90 anti-crispr (Acr) protein family HMMs. Their IDs are not named as APISxx, but as Acrxx, following https://tinyurl.com/anti-CRISPR. The 90 Acr HMMs are not included in the website though.

# 07/19/2023 update (by Yuchen Yan)
Add 4 newly curated experimental verified genes, one of them (gp54) is single gene that didn't form family.
Create 4 new APIS families (APIS090-093).

# 06/29/2023

Database of anti-prokaryotic immune system (dbAPIS) collects 37 experimental verified genes. Two of them (ArdB and Stp) didn't form family.
88 families HHMs were built on the homologous genes of 35 seed proteins.
The APIS028 was deleted since the seed protein does not meet the criteria.

Here we provide the download files of dbAPIS. (by Jinfang Zheng 06/29/2023)

1. dbAPIS.hmm
	Profile HMMs of APIS families (including anti-CRISPR)
2. anti_defense.pep
	APIS protein sequences (including anti-CRISPR)
3. each_family_hmm.tar.bz2
	HMM models of APIS family, each family has one file in the tarball 
4. each_family_msa.tar.bz2
	Multiple sequence alignment of APIS, each family has one file in the tarball 
5. each_family_protein.tar.bz2
	Protein seqeunce of dbAPIS, each family has one file in the tarball 
6. representive_protein_genomic_context.tar.bz2
	Genomic context of each family including 5 upsteam and downsteam genes property
7. seed_pro.fasta
	Seed protein sequences of dbAPIS
8. seed_family_member.tsv  (including anti-CRISPR)   [Replaced by seed_and_familyrep_all_infor.tsv and family_member_infor.tsv]
	The mapping table of seeds and homologs
9. acr_family.tar.bz2
	HMM models, protein seqeunces and multiple sequence alignment of anti-CRISPR data
10. parse_annotation_result.sh
	Script for parsing annotation output file
11. TableS1.tsv
	Classification of 4,428 APIS protein sequences in dbAPIS (clan, family, inhibited immune systems, Pfam, PHROG, host)
12. APIS_structure_data.tar.bz2
	The archieve includes: 
		1. AF/ contains Alphafold predicted structures of 4k+ APIS proteins (seeds and homologs) 
		2. rep_3D/ contains seed structures from PDB (only those that have PDB strcutures)
		3. foldseek_output/ contains afdb/esmdb hits results of the representative protein of each family (only include those that have hits)
		4. rep_3D_mapping_ids.tsv
13. readme.txt
	The file you are currently reading

##########################################
##### Run hmmer on your local server #####
##########################################

# download the APIS protein family profile HMMs
wget https://bcb.unl.edu/dbAPIS/downloads/dbAPIS.hmm

# prepare a profile database by constructing binary compressed datafiles
hmmpress dbAPIS.hmm
# Four files are created: dbAPIS.hmm.h3m, dbAPIS.hmm.h3i, dbAPIS.hmm.h3f, and dbAPIS.hmm.h3p.

# run hmmscan for your amino acid sequences
hmmscan --domtblout hmmscan.out --noali dbAPIS.hmm your_sequence.faa
# "--domtblout" option produces the space-separated domain hits table. There is one line for each domain. "--noali" option is used to omit the alignment section from output and reduce the output volume. More hmmscan information please see http://eddylab.org/software/hmmer/Userguide.pdf

############################################
##### Run diamond on your local server #####
############################################

# download the APIS protein sequences
wget https://bcb.unl.edu/dbAPIS/downloads/anti_defense.pep

# Build diamond database with APIS protein sequences
diamond makedb --in anti_defense.pep -d APIS_db

# run diamond for your amino acid sequences
diamond blastp --db APIS_db -q your_sequence.faa -f 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen -o diamond.out --max-target-seqs 10000
# "-f 6" option generates tabular-separated format (a BLAST output format using the option -outfmt 6), which composed of the customized fields. "--max-target-seqs" means maximum number of target sequences to report alignments for. More diamond details please see https://github.com/bbuchfink/diamond/wiki/1.-Tutorial

####################################
##### Parse annotation output  #####
####################################

# download the family member mapping table and parser script
wget https://bcb.unl.edu/dbAPIS/downloads/seed_family_mapping.tsv
wget https://bcb.unl.edu/dbAPIS/downloads/parse_annotation_result.sh

# run script to parse annotation output files
bash parse_annotation_result.sh hmmscan.out diamond.out
# This will generate parsed output files of hmmscan and diamond respectively

### parsed output interpretion ###
hmmscan.out.parsed.tsv contains 13 columns: 
	1.Query: query sequence ID
	2.Query len: query sequence length
	3.Hit family: hit family ID
	4.Defense type: hit family inhibited defense system type
	5.Hit CLAN: hit clan ID
	6.Hit CLAN defense type: hit clan inferred (predicted) inhibited defense system type
	7.Family len: length of the target family profile
	8.Domain c-evalue: the “conditional E-value”, a permissive measure of how reliable this particular domain may be
	9.Domain score: the bit score for this domain
	10.Query from: query start position
	11.Query to: query end position
	12.HMM from: the start of the MEA alignment of this domain with respect to the profile
	13.HMM to: the end of the MEA alignment of this domain with respect to the profile

diamond.out.parsed.tsv contains 12 columns:
	1.qseqid: query sequence ID 
	2.famid: hit family ID 
	3.Defense type: hit family inhibited defense system type 
	4.Hit CLAN: hit clan ID 
	5.Hit CLAN defense type: hit clan inferred (predicted) inhibited defense system type 
	6.seqid: hit sequence ID 
	7.pident: the percentage of identical amino acid residues that were aligned
   	8.align length: the total length of the alignment, including matching, mismatching and gap positions of query and subject
	9.evalue: the expected value of the hit
	10.bitscore: a scoring matrix independent measure of the (local) similarity of the two aligned sequences, with higher numbers meaning more similar
	11.qcov: query coverage, the percentage of the query sequence that aligned 
	12.scov: subject coverage, the percentage of the hit sequence that aligned




