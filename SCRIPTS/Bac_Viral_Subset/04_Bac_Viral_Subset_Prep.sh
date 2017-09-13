#!/bin/bash
#PBS-l nodes=2
#PBS-l walltime=1000:00:00
#PBS -j oe
#PBS -q default
#PBS -o out_Bac_Viral_subset_prep
#PBS -e err_Bac_Viral_subset_prep
#PBS -m ae -M erin_roberts@my.uri.edu

#04_Bac_Viral_Subset_prep.sh
#This script subsets the output of Stringtie to only include those scripts that have gene information,
cd /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/Bac_Viral_subset
F=/data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/Bac_Viral_subset

#array1=($(ls $F/*.merged.gtf))
#NOTE: IF GOAL IS DEG ANALYSIS, DO NOT PERFORM THIS STEP... Should subset in R, after calculations complete
#for i in ${array1[@]}; do 
#	grep "gene:" ${i} > $(echo ${i}|sed "s/\..*//").subset.gff3HIT #this greps all lines with genes and transcripts
#	grep "MSTRG" ${i}  > $(echo ${i}|sed "s/\..*//").subset.MSTRGs #Use these later for BLAST2GO analysis
#	echo "subset done" $(date)
#done


#Protocol to generate count matrices for genes and transcripts for import into DESeq2 using (prepDE.py) to extract this read count information directly from the files generated by StringTie (run with the -e parameter).
	#generates two CSV files containing the count matrices for genes and transcripts, Given a list of GTFs, which were re-estimated upon merging create sample_list.txt

#Generate count matrices using prepDE.py, prep_DE.py accepts a .txt file listing sample IDs and GTFs paths 
#create sample_list.txt
#template: SRR334318 /data3/marine_diseases_lab/erin/Bio_project_SRA/pipeline_files/SRR334318.merge.gtf

array2=($(ls *.merged.gtf))

for i in ${array2[@]}; do
	echo "$(echo ${i}|sed "s/\..*//") $F/${i}" >> Bac_Viral_sample_list.txt
done

python prepDE.py -i Bac_Viral_sample_list.txt
			
echo "STOP" $(date)