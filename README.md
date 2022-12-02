
![Logo](/Assets/ribosome_3d.png)




# Role of Ribosomal Heterogeneity in Chronic Stress

This repository contains the code utilized for the paper:

**Title: Role of ribosomal heterogeneity in chronic stress**

**Authors:** TBD

**DOI:** TBD

## Alignment Code
The file **Alignment/Hisat_alignment_code.sh** contains the Linux shell scripts utilized to align the fastq files of the RNA-Seq data

The following Linux modules need to be installed to run this script:
- Hisat2 _(the version used in this work is 2.1.0)_
- samtools _(the version used in this work is 1.9)_

It is highly recommended to use a multiprocessing environement for parallel processing.
All our alignment processing was performed on [Ohio Supercomputers Center (OSC)](https://www.osc.edu/) with two Nodes and 6 CPUs per task.

