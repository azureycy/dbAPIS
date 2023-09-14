import sys,os
from Bio import SeqIO
def add_taxa():
    all_lines = open("all_infor.tsv").readlines()
    header = ["d","p","c","o","f","g",'s']
    new_head = all_lines[0].rstrip("\n").split("\t")+header
    print("\t".join(new_head))
    
    for line in all_lines[1:]:
        lines = line.rstrip("\n").split("\t")
        lineage = lines[10].split(";")
        if len(lineage) != 7:
            lineage += (7-len(lineage))*[""]
    
        new_line = lines+lineage
        print("\t".join(new_line))

import json
def add_plddt():
    all_lines = open("all_infor.tsv").readlines()[1:]
    for line in all_lines:
        lines = line.rstrip("\n").split("\t")
        plddt_file = sys.argv[1] +lines[0]
        
        if os.path.exists(plddt_file):
            with open(plddt_file) as file:
                data = json.load(file)
        
            print(f'{lines[0]}\t{data["ptm"]}')
        else:
            print(f'{lines[0]}\t0')

#add_plddt()

def add_family_ID_for_seq():
    all_families_seqs = [filename for filename in os.listdir() if filename.endswith(".fasta")]
    
    for filename in all_families_seqs:
        famid = filename.split(".")[0]
        seqs = []
        for seq in SeqIO.parse(filename,'fasta'):
            seq.id = famid + "|" +seq.id
            seqs.append(seq)
        SeqIO.write(seqs,famid+".pep",'fasta')

#add_family_ID_for_seq()
#exit()

def add_information_hhsearch_result():
    all_families_seqs = [filename for filename in os.listdir() if filename.endswith("blsttab.out.filt")]
    family_lines ={line.split()[0]:line.split("\t") for line in open(sys.argv[1])}
    for filename in all_families_seqs:
        famid = filename.split(".")[0]
        w_files = open(famid+".hhsearch.txt",'w')
        for line in open(filename):
            hhsearch = line.split()
            famid = hhsearch[0]
            try:
                lines = family_lines[famid]
                hhsearch.append(lines[3])
                hhsearch.append(lines[6])
            except:
                hhsearch.append(" ")
                hhsearch.append(" ")
            new_line = "\t".join(hhsearch) +"\n"
            w_files.write(new_line)
add_information_hhsearch_result()

def create_member_table():
    for record in SeqIO.parse(sys.argv[1],'fasta'):
        ids  = record.id.split("|")
        famid = ids[0]
        seqid = "|".join(ids[1:len(ids)])
        seq   = record.seq
        print(f"{famid}\t{seqid}\t{seq}")

#create_member_table()
#exit()

def add_plddt_for_member():
    all_lines = open("member.info.txt")
    for line in all_lines:
        lines = line.rstrip("\n").split("\t")
        plddt_file =  lines[1]+ ".score.json"
        
        if os.path.exists(plddt_file):
            with open(plddt_file) as file:
                data = json.load(file)
        
            lines.append(str(data["ptm"]))
        else:
            lines.append("0")
        print("\t".join(lines))

#add_plddt_for_member()
#exit()
def split_sequence_invidual():
    for record in SeqIO.parse("anti_defense.pep",'fasta'):
        ids = record.id
        seqid = "|".join(ids.split("|")[1:len(ids.split("|"))])
        SeqIO.write([record],f"seqs/{seqid}.fasta","fasta")

#split_sequence_invidual()
