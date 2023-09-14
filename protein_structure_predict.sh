## The protein structure was predicted with ColabFold, which incorperates mmseqs to generate MSA input features.

#!/bin/bash

# Download ColabFold databases (940GB).
./setup_databases.sh /path/to/db_folder

# Generate multiple sequence alignments (MSAs) and search against the ColabFoldDB
  # This needs a lot of CPU
colabfold_search -db-load-mode 3 --use-templates 1 --threads 32 ${APIS_protein_id}.fasta /path/to/db_folder ${APIS_protein_id}.msa
  # This needs a GPU
colabfold_batch ${APIS_protein_id}.msa ${APIS_protein_id}.predict.pdb --use-gpu-relax --num-models 1 --amber --max-msa 512:5120

# This will create folder that contains all input MSAs formated as a3m files and a predictions folder with all predicted pdb,json and png files.
