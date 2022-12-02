###This file contains the aligment comamnds for both 
###refernce and composite genome

#!/bin/sh

###Index path (of either the reference genome or the composite genome):
idx_dir="<Path/To/Your/Index>"

###Pathe to the splicesites file needed for the Hisat2
splice_dir="<Path/To/Your/Hisat2/Splicesites>"

###Path to FastQ files folder
SRC_DIR="<Path/To/Your/FastQ>"

###Output directory
out_dir="<Path/To/Your/OutPut>"

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



