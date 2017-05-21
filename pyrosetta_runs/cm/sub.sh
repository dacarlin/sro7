#!/bin/bash 
#SBATCH -J sro7
#SBATCH -o log.txt 
#SBATCH -t 0-05:00

module load use.own 
module load hmmer promals rosetta 

localp=/share/work/alex/local_pdb/sequences/pdb_seqres.txt

#cp -r input_pkg output_files 
cd output_files 

# search for homologs 
#phmmer --tblout table.out -A aln.fasta target.fasta $localp
#awk 'NR>3 {print $1}' table.out | head -5 > templates.txt 
python process_hmmer.py

# structural alignment 
source activate py27 
promals templates.fasta
source deactivate 

# partial thread 
python partial_thread.py 
partial_thread.linuxgccrelease @pt_flags

# hybridize 
python hyb.py 
