<img src="https://github.com/azureycy/dbAPIS/assets/90859231/ac60e454-ecc0-4cdc-8419-35cdf3db2588" width=65% height=65%>

# Tools and databases
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

# Database content processing
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
  - AlphaFold2 

### Searching protein structure homologs using Foldseek
  - [foldseek_homolog_structure.sh](https://github.com/azureycy/dbAPIS/blob/main/foldseek_homolog_structure.sh)

### Genomic context visualization using jbrowse
  - [generate_jbrowse.sh](https://github.com/azureycy/dbAPIS/blob/main/generate_jbrowse.sh)

### Gene cluster comparison using clinker
  - [clinker_gene_loci_plot.sh](https://github.com/azureycy/dbAPIS/blob/main/clinker_gene_loci_plot.sh)

# Run APIS protein annotation with DIAMOND and HMMscan locally

### Run HMMscan on your local server

Download the APIS protein family profile HMMs
```
wget https://bcb.unl.edu/dbAPIS/downloads/anti_defense.hmm
```

Run hmmscan for your amino acid sequences
```
hmmpress anti_defense.hmm
hmmscan anti_defense.hmm your_sequence.faa > output.txt
```

### Run diamond on your local server 
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
diamond blastp -d APIS_db -q your_sequence.fasta -o output.tsv
```
