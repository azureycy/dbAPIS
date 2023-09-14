## Searching homologous families using HHsearch of hh-suit software

#!/bin/sh

# build msa dataindex 
ffindex_build -s allfamily_msa.ff{data,index} family_msa

# from msa dataindex to get a3m dataindex
ffindex_apply allfamily_msa.ff{data,index} -i allfamily_a3m.ffindex -d allfamily_a3m.ffdata -- hhconsensus -M 50 -maxres 65535 -i stdin -oa3m stdout -v 0
 
# from a3m dataindex to get hhm dataindex
ffindex_apply allfamily_a3m.ff{data,index} -i allfamily_hhm.ffindex -d allfamily_hhm.ffdata -- hhmake -i stdin -o stdout -v 0

# from a3m dataindex to get cs219 dataindex
cstranslate -f -I a3m -i allfamily_a3m -o allfamily_cs219

# order the dataindex
sort -k3 -n -r allfamily_cs219.ffindex | cut -f1 > sorting.dat
ffindex_order sorting.dat allfamily_hhm.ff{data,index} allfamily_hhm_ordered.ff{data,index}
mv allfamily_hhm_ordered.ffindex allfamily_hhm.ffindex
mv allfamily_hhm_ordered.ffdata allfamily_hhm.ffdata
ffindex_order sorting.dat allfamily_a3m.ff{data,index} allfamily_a3m_ordered.ff{data,index}
mv allfamily_a3m_ordered.ffindex allfamily_a3m.ffindex
mv allfamily_a3m_ordered.ffdata allfamily_a3m.ffdata

# run hhsearch using msa fasta as input  (use -M first for msa fasta format generates same results as using a3m format input)
for i in `ls family_msa/ |grep faa`;
do hhsearch -i family_msa/$i -d hhsuitdb/allfamily -M first -o hhsearch_output/${i%%.*}.hhr -blasttab hhsearch_output/${i%%.*}.blsttab.out;
done

# filter hhsearch hits of family homologs
for i in *.blsttab.out;
do echo -e "target\tpident\talnLen\t#mismatch\t#gapopen\tqstart\tqend\ttstart\ttend\teval\tbitscore" > "$i.filt";
awk -v OFS="\t" '$11 <= 1e-5 {sub(/\..*/, "", $2); print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' "$i" >> "$i.filt"
done

