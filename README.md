<img src="https://github.com/azureycy/dbAPIS/assets/90859231/ac60e454-ecc0-4cdc-8419-35cdf3db2588" width=70% height=70%>

## Tools
- [Blast+](https://github.com/ncbi/blast_plus_docs): compare sequences to database.
- [MMseqs2](https://github.com/soedinglab/MMseqs2): sequence search and clustering.
- [MAFFT](https://mafft.cbrc.jp/alignment/software/): multiple sequence alignment.
- [HMMER](https://github.com/EddyRivasLab/hmmer): sequence analysis using profile HMMs.
- [hh-suite](https://github.com/soedinglab/hh-suite): remote protein homology detection suite.
- [Foldseek](https://github.com/steineggerlab/foldseek): protein structure comparison.
- [DIAMOND](https://github.com/bbuchfink/diamond): sequence aligner for protein and translated DNA searches.

## database content processing
### Create APIS protein families
- BLASTP homology search: 
- MMseqs2 clustering:

### Add new APIS protein families
- BLASTP homology search:
- MMseqs2 searching:

### Build APIS protein family HMMs 
- Multiple sequence alignment

### Group APIS protein families into clans using HHsearch 

### Protein function annotation
Pfam:
PHROG: 
AlphaFold2 
Foldseek 

## Run APIS protein annotation with DIAMOND and HMMscan locally

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
