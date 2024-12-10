# CNV_SV_Parliament2

This is a Parliament2 Singularity container based workflow for processing structural variants of .bam files.

Data folder contains list of bam files and list of target folders where each bam file were processed for structural variants by Parliament2 workflow.

## Splitting 221 bam file list
## ----------------------------
src folder contains ***folder_run_split.sh*** which split the list of bams and folder into a chunk of 10 bams and 10 corresponding folders which will be used to run the Parliament2 SV calling process in one batch. Thus in one job submission in a cluster it will run 10 bam files. Parallely 21 process will be running simultanaeously to complete 221 total bam files.

## Running first job
## ----------------------
 *bash b00_lumpy_00.sh*  
 
 will take input of 

  **ds_221_b00**
  
  **f_221_00**

Output file name will be automatically generate by the script depending upon the input bam file name

## Alternative Parliament2 run
Instead of the above script if someone wants to run few bams for that one can use

*loop_11_15_parl2_run.sh*

One need to supply corresponding bam and folder list.

## SV count
After processing all the bams if someone interested to count how many different SV were called for each bam files and generate a table, they can run

***sv_counts_CU167_v2.py***

It will generate a tab delimited file of each bam file's
* INS,
* DEL,
* DUP and
* BND
  
 Also it will report total number of SV for each bam.


