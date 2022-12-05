
![Logo](/Assets/ribosome_3d.png)




# Role of Ribosomal Heterogeneity in Chronic Stress

This repository contains the code utilized for the paper:

**Title:** _Role of ribosomal heterogeneity in chronic stress_

**Authors:** TBD

**DOI:** TBD

## Alignment Code
The file **Alignment/Hisat_alignment_code.sh** contains the Linux shell scripts utilized to align the fastq files of the RNA-Seq data

The following Linux modules need to be installed to run this script:
- [Hisat2](http://daehwankimlab.github.io/hisat2/) _(the version used in this work is 2.1.0)_
- [Samtools](https://www.htslib.org/) _(the version used in this work is 1.9)_

It is highly recommended to use a multiprocessing environement for parallel processing.
All our alignment processing was performed on [Ohio Supercomputers Center (OSC)](https://www.osc.edu/) with two Nodes and 6 CPUs per task.


### To align to reference genome:
 - Built the index for Hisat2 using the reference genome.
 - Change **idx_dir** to the path to your reference genome index directory.
 - Use the Hisat command with the option _--avoid-pseudogene_ to avoid pseudogenes.

### To align to the composite genome:
 - Built the index for Hisat2 using the composite genome.
 - Change **idx_dir** to the path to your composite genome index directory.
 - OPTIONAL: use the Hisat command with the option _--avoid-pseudogene_ to avoid pseudogenes.
 
## GO parent child code
The file **R/ParentChild.R** contains the R code utilized to generate:
 - Get the frquencies of the ancestors of the GO terms of interest.
 - Get the truth tables of the ancestors of interest.
 
 
