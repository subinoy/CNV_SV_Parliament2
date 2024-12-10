#!/bin/bash

# Split the bam file list into chunk of 10 bam files at a time
# Sequence number of bam file chunk will be added at the end of
# ds_221_b and form ds_221_b00
# 'b' -> bam file list
split -l 10 -d -a 2 ds_221_bam_fullpath.txt ds_221_b

# Split the folder_run list into chunk of 10 folders at a time
# Sequence number of folder file chunk will be added at the end of
# f_221_ and form f_221_00
# 'f' -> folder list
split -l 10 -d -a 2 lumpy_221_folder.txt f_221_
