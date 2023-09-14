#!/bin/bash

# make index for genome
samtools faidx $genome_genome_name.fna
# add genome to JBrowse
jbrowse add-assembly $genome_name.fna --out $genome_name --load copy
# sorted GFF file
gt gff3 -sortlines -tidy -retainids $genome_name.gff > $genome_name.sorted.gff
bgzip $genome_name.sorted.gff 
# tar and compress GFF file  
tabix $genome_name.sorted.gff.gz
# add one track to JBrowse
jbrowse add-track $genome_name.sorted.gff.gz --out $genome_name --load move --trackId GFF
# set the default view
jbrowse set-default-session -t GFF --out $genome_name -v LinearGenomeView -n GFF --viewId view
