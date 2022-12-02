###This file contains the aligment comamnds for both 
###refernce and composite genome

#!/bin/sh

###Needs reference genome
idx_dir="/fs/scratch/PJS0309/Grch38/Hisat2/Grch38/Grch38"
#idx_dir="/fs/scratch/PJS0309/Grch38/Hisat2/Grch38/gc"

splice_dir="/fs/scratch/PJS0309/Grch38/Hisat2/Grch38/splicesites.tsv"

###Needs reference genome
SRC_DIR="/fs/scratch/PJS0310/Xiaolu-Labonte/Labonte_Human_vSUB/"
out_dir="/fs/scratch/PJS0310/Xiaolu-Labonte/Labonte_Human_vSUB/Labonte_Human_vSUB_bam/"

cd $SRC_DIR
for file in *_1.fastq.gz;
do
Base_Name=${file%.fastq.gz}
out_file=${Base_Name%_*}
out_name=${out_dir}${out_file}.bam
#echo ${Base_Name}
#echo ${out_file}
R1_File=${out_file}_1.fastq.gz
R2_File=${out_file}_2.fastq.gz


echo "hisat2 -x ${idx_dir} --known-splicesite-infile ${splice_dir} --avoid-pseudogene -p 3 -1 ${SRC_DIR}${R1_File}, -2 ${SRC_DIR}${R2_File} --trim3 0 --trim5 0 | samtools view -bS | samtools sort > ${out_name}"

done





