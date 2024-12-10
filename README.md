# Parliament2 Singularity Workflow for Structural Variant Analysis

This workflow is designed to process structural variants (SVs) from .bam files using the Parliament2 pipeline within a Singularity container. Below are the details of the workflow structure and usage instructions.

# Data Structure
The data folder contains:

A list of BAM files.
A corresponding list of target folders where each BAM file will be processed by the Parliament2 workflow.


## Splitting the 221 BAM File List
## ----------------------------
The src folder includes the script ***folder_run_split.sh***, which divides the list of BAM files and target folders into chunks of 10 files each.

## Features:
Each chunk contains 10 BAM files and their corresponding output folders.
This enables efficient processing by running one batch (10 files) per job submission in a cluster environment.
In total, 21 parallel processes will run simultaneously to process all 221 BAM files.

## Running the First Job
## ----------------------
To initiate the workflow, execute the following command:

  *bash b00_lumpy_00.sh* 

### Inputs:
  - **ds_221_b00**: The BAM file list for this batch.

  - **f_221_00**: The folder list for this batch.
  
### Output:
The script automatically generates output file names based on the input BAM file names.



## Alternative Parliament2 Workflow

For processing a smaller number of BAM files without using the full pipeline, you can use the script:

  *loop_11_15_parl2_run.sh*

Usage:
Provide the corresponding BAM file list and target folder list as inputs to this scri

## Counting Structural Variants (SVs)
After processing all BAM files, you can count and summarize the detected structural variants using the script:

  ***sv_counts_CU167_v2.py***

Output:
The script generates a tab-delimited file that includes the following SV counts for each BAM file:

  - **INS**: Insertions

  - **DEL**: Deletions

  - **DUP**: Duplications

  - **BND**: Breakends

  - **Total**: Total number of SVs detected


This table provides an overview of SVs across all processed BAM files.




