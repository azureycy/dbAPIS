#!/bin/sh

# parse hmmscan output
grep -v "#" hmmscan.domtblout |awk -v OFS='\t' '{print $4,$6,$1,$3,$12,$14,$20,$21,$16,$17}'|join -t $'\t' -1 3 -2 1 -a 1 <(sort -t $'\t' -k3,3 -) <(cut -f1,3,4,5 Seed_family_mapping.tsv |sort -t $'\t' -uk1,1)|awk -F '\t' -v OFS='\t' '{print $2,$3,$1,$11,$12,$13,$4,$5,$6,$7,$8,$9,$10}'| sort -t $'\t' -k1,1 -k8,8n | sed '1i Query\tQuery len\tHit family\tDefense type\tHit CLAN\tHit CLAN defense type\tFamily len\tDomain c-evalue\tDomain score\tQuery from\tQuery to\tHMM from\tHMM to' > hmmscan.parsed.domtblout

# parse diamond output
awk -F'\t' -v OFS='\t' '{sub(/\|/, "\t", $2)} 1' diamond.out | join -t $'\t' -1 3 -2 2 -a 1 <(sort -t $'\t' -k3,3 -) <(sort -t $'\t' -k2,2 Seed_family_mapping.tsv) | awk -F'\t' -v OFS='\t' '{print $2,$3,$17,$18,$19,$1,$4,$5,$12,$13,($9 - $8 + 1)/$14,($11 - $10 + 1)/$15}'|sort -t $'\t' -k1,1 -k7,7nr | sed '1i qseqid\tfamid\tDefense type\tHit CLAN\tHit CLAN defense type\tseqid\tpident\talign length\tevalue\tbitscore\tqcov\tscov' > diamond.parsed.out
