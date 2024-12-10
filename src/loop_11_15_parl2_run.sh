#!/bin/bash

# Loop through folder and bam counter input files from 11 to 15
for counter in {11..15}; do
    # Read folder names into an array
    folders=()
    while IFS= read -r folder; do
        folders+=("$folder")
    done < "f_221_$counter"

    # Read BAM file names into an array
    bamfiles=()
    #counter=0
    while IFS= read -r bamfile; do
        bamfiles+=("$bamfile")
        ((counter++))
    done < "ds_221_b$counter"

    # Ensure the number of folders and BAM files are the same
    if [ "${#folders[@]}" -ne "${#bamfiles[@]}" ]; then
        echo "Error: Number of folders and BAM files do not match"
        exit 1
    fi

    # Loop over the folders and BAM files
    for ((i=0; i<"${#folders[@]}"; i++)); do
        folder="${folders[$i]}"
        bamfile="${bamfiles[$i]}"

        
        # Extract the filename from the BAM path
        bamfilename=$(basename "$bamfile")

        # Create the folder
        target_folder="/mnt/vast/hpc/lee_lab/subi_work/DS_lumpy/$folder"
        ref_file="/mnt/vast/hpc/lee_lab/subi_work/PSEN1_results/parl2/Homo_sapiens_ref38.fasta"

        # Create the folders but do not proceed further
        mkdir -p "$target_folder"

        cd "$target_folder"
        ln -sf "$bamfile" "$bamfilename"
        ln -sf "$bamfile.bai" "$bamfilename.bai"
        ln -sf "$ref_file" "Homo_sapiens_ref38.fasta"
        ln -sf "$ref_file.fai" "Homo_sapiens_ref38.fasta.fai"
        cp /mnt/vast/hpc/homes/sb4715/PSEN1_Manta/psen1_input/Aug_18/parliament2_latest.sif .


        # Change to the created folder
        echo "$PWD"
        # Process the BAM file within the folder
        echo "Processing BAM file: $bamfilename in folder: $target_folder"

        # Add your processing commands here
        singularity run --bind "$target_folder/":"/home/dnanexus/in" \
        --bind "$target_folder/":"/home/dnanexus/out" parliament2_latest.sif \
        --bam "$bamfilename" \
        --bai "$bamfilename.bai" \
        --fai "Homo_sapiens_ref38.fasta.fai" \
        -r "Homo_sapiens_ref38.fasta" --lumpy

        # Remove the Singularity container once processing is complete
        rm parliament2_latest.sif

    done
done
