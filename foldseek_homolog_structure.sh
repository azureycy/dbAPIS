## Searching protein structure homologs using foldseek

#!/bin/sh

# upload pre-generated Alphafold and ESM databases in foldseek
foldseek databases Alphafold/UniProt50 afdb tmp
foldseek databases ESMAtlas30 esmdb tmp

# use structure pdb files as input to run foldseek
mkdir foldseek_output
prot_id_list=$1

for prot_id in $prot_id_list;
do 
  foldseek easy-search ${prot_id}.pdb.gz afdb foldseek_output/afdb/${prot_id}.afdb.out tmp -e 1e-5 --alignment-type 1 --format-output "query,target,alntmscore,u,t,prob,qstart,qend,tstart,tend,evalue,lddt,lddtfull" --tmscore-threshold 0.45 --threads 16;
  foldseek easy-search ${prot_id}.pdb.gz afdb foldseek_output/afdb/${prot_id}.afdb.html tmp -e 1e-5 --alignment-type 1 --format-mode 3 --tmscore-threshold 0.45 --threads 16;
  foldseek easy-search ${prot_id}.pdb.gz esmdb foldseek_output/esmdb/${prot_id}.esmdb.out tmp -e 1e-5 --alignment-type 1 --format-output "query,target,alntmscore,u,t,prob,qstart,qend,tstart,tend,evalue,lddt,lddtfull" --tmscore-threshold 0.45 --threads 16;
  foldseek easy-search ${prot_id}.pdb.gz esmdb foldseek_output/esmdb/${prot_id}.esmdb.html tmp -e 1e-5 --alignment-type 1 --format-mode 3 --tmscore-threshold 0.45 --threads 16;
done

# remove empty foldseek output
for i in `find foldseek_output/ -name *.out`; do 
    if [ ! -s $i ] && [ $(stat -c%s "${i%.*}.html") -le 2607446 ]; then 
        rm $i ${i%.*}.html
    fi
done

# parse foldseek tabular output: unique by target and sorted by foldseek e-value
for i in `find foldseek_output/ -name *.out`;
do cut -f1,2,3,6,7,8,9,10,11 $i | sort -u -k2,2 | awk '{ gsub(".pdb.*", ".pdb", $1); print }'| \
	sed 's/ /\t/g' | sed 's/.pdb.gz/.pdb/' | sort -rnk9,9 | \
	sed '1i query\ttarget\talntmscore\tprob\tqstart\tqend\ttstart\ttend\tevalue' > $i.111;
mv $i.111 $i;
head -n 11 $i > $i.top10
done
