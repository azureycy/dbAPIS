#!/bin/bash

# from Jinfang on bcb
### sudo cp  all_infor.tsv /var/lib/mysql-files/all_infor.tsv
mysql -u root -p -P 3306 -D anti_defense << EOF
drop TABLE repository;
CREATE TABLE repository(
	id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Anti_defense_family_ID varchar(50),
	representative_protein_accession varchar(500),
	AIMGs varchar(50),
	Family_HMM varchar(50),
	Inhibited_defense_system varchar(500),
	Phage varchar(500),
	Genome_accession varchar(50),
	Host_taxa varchar(200),
	PMID varchar(500),
	PMID_Link varchar(200),
	PDBID varchar(200),
	Paper varchar(200),
	Ref_Link varchar(1000),
	Description varchar(500),
	Prot_seq varchar(5000),
	Prot_Link varchar(500),
	Pfam_domain varchar(50),
	start varchar(10),
	end varchar(10),
	strand varchar(1),
	neighbor_start varchar(10),
	neighbor_end varchar(10),
	d varchar(50),
	p varchar(50),
	c varchar(50),
	o varchar(50),
	f varchar(50),
	g varchar(50),
	s varchar(50),
	ptm FLOAT,
	Host_TaxID varchar(20),
	verified BOOL NOT NULL DEFAULT FALSE,
	member_count  varchar(5),
	seqlen  varchar(5),
	IP FLOAT,
	MW FLOAT,
	Charge FLOAT,
	clan_system varchar(100),
	clan_ID varchar(50),
	clan_seed_family varchar(50),
	PHROG varchar(200),
	INDEX (Anti_defense_family_ID)
);

LOAD DATA INFILE '/var/lib/mysql-files/all_infor.tsv'
INTO TABLE repository
FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Anti_defense_family_ID,verified,AIMGs,Inhibited_defense_system,Paper,Ref_Link,representative_protein_accession,Prot_Link,Family_HMM,Phage,Genome_accession,Host_taxa,Host_TaxID,d,p,c,o,f,g,s,PMID,PMID_Link,PDBID,Description,Pfam_domain,Prot_seq,start,end,strand,neighbor_start,neighbor_end,member_count,seqlen,IP,MW,Charge,ptm,clan_system,clan_ID,clan_seed_family,PHROG);

drop table homologous;
CREATE TABLE homologous(
	id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Anti_defense_family_ID varchar(50),
	representative_protein_accession varchar(500),
	queryid varchar(100),
	subjectid varchar(500),
	pident varchar(20),
	length varchar(20),
	mismatch varchar(20),
	gapopen varchar(20),
	qstart varchar(20),
	qend varchar(20),
	sstart varchar(20),
	send varchar(20),
	evalue varchar(20),
	bitscore varchar(20),
	qcovs varchar(20),
	phage varchar(200),
	host varchar(50),
	TaxID varchar(20),
	Source varchar(20),
	Pfam_ID varchar(80),
	Phrog_ID varchar(200),
	INDEX (Anti_defense_family_ID)
);

LOAD DATA INFILE '/var/lib/mysql-files/family_member_blstout_host.tsv'
INTO TABLE homologous
FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Anti_defense_family_ID,representative_protein_accession,queryid,subjectid,pident,length,mismatch,gapopen,qstart,qend,sstart,send,evalue,bitscore,qcovs,phage,host,TaxID,Source,Pfam_ID,Phrog_ID);

drop table Member;
CREATE TABLE Member(
	id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Anti_defense_family_ID varchar(50),
	representative_protein_accession varchar(500),
	Protseq varchar(5000),
	ptm FLOAT
);
LOAD DATA INFILE '/var/lib/mysql-files/member.info.txt'
INTO TABLE Member
FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(Anti_defense_family_ID,representative_protein_accession,Protseq,ptm);
EOF
