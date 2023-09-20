<img src="https://github.com/azureycy/dbAPIS/assets/90859231/ac60e454-ecc0-4cdc-8419-35cdf3db2588" width=65% height=65%>

## dbAPIS website: https://bcb.unl.edu/dbAPIS

## Tools and databases
- [Blast+](https://github.com/ncbi/blast_plus_docs): compare sequences to database.
- [MMseqs2](https://github.com/soedinglab/MMseqs2): sequence search and clustering.
- [MAFFT](https://mafft.cbrc.jp/alignment/software/): multiple sequence alignment.
- [HMMER](https://github.com/EddyRivasLab/hmmer): sequence analysis using profile HMMs.
- [hh-suite](https://github.com/soedinglab/hh-suite): remote protein homology detection suite.
- [Foldseek](https://github.com/steineggerlab/foldseek): protein structure comparison.
- [DIAMOND](https://github.com/bbuchfink/diamond): sequence aligner for protein and translated DNA searches.
- [Pfam](https://www.ebi.ac.uk/interpro/entry/pfam/): protein domain family database.
- [PHROG](https://phrogs.lmge.uca.fr): prokaryotic Virus Remote Homologous Groups database.
- [ColabFold](https://github.com/sokrypton/ColabFold) for AlphaFold2 structure prediction.
- [clinker](https://github.com/gamcil/clinker/tree/master): gene cluster comparison figure generator

## Database content processing
### Create APIS protein families and add newly curated proteins
  - BLASTP homology search: [blast_seed.sh](https://github.com/azureycy/dbAPIS/blob/main/blast_seed.sh)
  - MMseqs2 clustering/searching: [create_family_and_update.sh](https://github.com/azureycy/dbAPIS/blob/main/create_family_and_update.sh)

### Build APIS protein family HMMs 
  - [family_msa_hmm.sh](https://github.com/azureycy/dbAPIS/blob/main/family_msa_hmm.sh)

### Searching homologous families using HHsearch
  - [hhsearch_homolog_family.sh](https://github.com/azureycy/dbAPIS/blob/main/hhsearch_homolog_family.sh)

### Protein function annotation
  - Pfam and PHROG annotation: [phrog_pfam_annotation.sh](https://github.com/azureycy/dbAPIS/blob/main/phrog_pfam_annotation.sh)

### Protein structure prediction
  - [protein_structure_predict.sh](https://github.com/azureycy/dbAPIS/blob/main/protein_structure_predict.sh)

### Searching protein structure homologs using Foldseek
  - [foldseek_homolog_structure.sh](https://github.com/azureycy/dbAPIS/blob/main/foldseek_homolog_structure.sh)

### Genomic context visualization using jbrowse
  - [generate_jbrowse.sh](https://github.com/azureycy/dbAPIS/blob/main/generate_jbrowse.sh)

### Gene cluster comparison using clinker
  - [clinker_gene_loci_plot.sh](https://github.com/azureycy/dbAPIS/blob/main/clinker_gene_loci_plot.sh)

## Run APIS protein annotation with DIAMOND and HMMscan locally

### Run HMMscan on your local server

Download the APIS protein family profile HMMs
```
wget https://bcb.unl.edu/dbAPIS/downloads/dbAPIS.hmm
```
prepare a profile database by constructing binary compressed datafiles
```
hmmpress dbAPIS.hmm
```
Four files are created: dbAPIS.hmm.h3m, dbAPIS.hmm.h3i, dbAPIS.hmm.h3f, and dbAPIS.hmm.h3p.

Run hmmscan for your amino acid sequences
```
hmmscan --domtblout hmmscan.out --noali dbAPIS.hmm your_sequence.faa
```
`--domtblout` option produces the space-separated domain hits table. There is one line for each domain. `--noali` option is used to omit the alignment section from output and reduce the output volume. More hmmscan information please see [hmmer user guide](http://eddylab.org/software/hmmer/Userguide.pdf).

### Run DIAMOND on your local server 
Download the APIS protein sequences
```
wget https://bcb.unl.edu/dbAPIS/downloads/anti_defense.pep
```
Build diamond database with APIS protein sequences
```
diamond makedb --in anti_defense.pep -d APIS_db
```
Run diamond for your amino acid sequences
```
diamond blastp --db APIS_db -q your_sequence.faa -f 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen -o diamond.out --max-target-seqs 10000
```
`-f 6` option generates tabular-separated format (a BLAST output format using the option -outfmt 6), which composed of the customized fields. `--max-target-seqs` means maximum number of target sequences to report alignments for. More diamond details please see [diamond tutorial](https://github.com/bbuchfink/diamond/wiki/1.-Tutorial).

### Parse annotation output

Download the family member mapping table and parser script
```
wget https://bcb.unl.edu/dbAPIS/downloads/Seed_family_mapping.tsv
wget https://bcb.unl.edu/dbAPIS/downloads/parse_annotation_result.sh
```

Run script to parse annotation output files
```
bash parse_annotation_result.sh hmmscan.out diamond.out
```
This will generate parsed output files of hmmscan and diamond respectively
* hmmscan.out.parsed.tsv contains 13 columns: 
	1. Query: query sequence ID
2.Query len: query sequence length
3. Hit family: hit family ID
⋅⋅⋅4.Defense type: hit family inhibited defense system type
⋅⋅⋅5.Hit CLAN: hit clan ID
	6.Hit CLAN defense type: hit clan inferred (predicted) inhibited defense system type
	7.Family len: length of the target family profile
	8.Domain c-evalue: the “conditional E-value”, a permissive measure of how reliable this particular domain may be
	9.Domain score: the bit score for this domain
	10.Query from: query start position
	11.Query to: query end position
	12.HMM from: the start of the MEA alignment of this domain with respect to the profile
	13.HMM to: the end of the MEA alignment of this domain with respect to the profile

* diamond.out.parsed.tsv contains 12 columns:
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


