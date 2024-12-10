#!/bin/bash
# Read folder names into an array
# Run the program with target folder as run folder and input folder for Singularity

counter=0
while IFS= read -r folder; do
  folders[counter]="$folder"
  ((counter++))
done < f_221_00

# Read BAM file names into an array
counter=0
while IFS= read -r bamfile; do
  bamfiles[counter]="$bamfile"
  ((counter++))
done < ds_221_b00

# Ensure the number of folders and BAM files are the same
if [ "${#folders[@]}" -ne "${#bamfiles[@]}" ]; then
  echo "Error: Number of folders and BAM files do not match"
  exit 1
fi

# Loop over the folders and BAM files
# and take the bam file name and corresponding target folder name
for ((i=0; i<"${#folders[@]}"; i++)); do
  folder="${folders[$i]}"
  bamfile="${bamfiles[$i]}"
  
  # Extract the filename from the BAM path
  bamfilename=$(basename "$bamfile")
  
  # Create the target folder each time for each bam file
  # thereby all the run will keep its own run folder and the results
  # along with log and other files
  target_folder="/mnt/vast/hpc/lee_lab/subi_work/DS_lumpy/$folder"
  #input_folder="/mnt/mfs/hgrcgrid/homes/sb4715/PSEN1_Manta/psen1_input/Aug_25_input/$folder"
  #input_folder=$bamfile
  # Human reference fasta file
  ref_file="/mnt/vast/hpc/lee_lab/subi_work/PSEN1_results/parl2/Homo_sapiens_ref38.fasta"
  
  # Create the target folder
  #mkdir -p "$input_folder"
  mkdir -p "$target_folder"

  # Create symbolic links in the input folder and enter into that target folder
  #cd "$input_folder"
  cd "$target_folder"
  
  # Instead of copying all the bam files and reference files to
  # the target folder which will be mapped to the "in" folder of
  # Singularity container and "in" act as input folder and 
  # that have to have all the input files, otherwise it will not run
  # 
  ln -sf "$bamfile" "$bamfilename"
  ln -sf "$bamfile.bai" "$bamfilename.bai"
  ln -sf "$ref_file" "Homo_sapiens_ref38.fasta"
  ln -sf "$ref_file.fai" "Homo_sapiens_ref38.fasta.fai"
  # Copy the Singularity instance to the dynamic target folder
  cp /mnt/vast/hpc/homes/sb4715/PSEN1_Manta/psen1_input/Aug_18/parliament2_latest.sif .
  # Change to the created folder
  #cd "$target_folder"
  echo "$PWD"
  # Process the BAM file within the folder
  echo "Processing BAM file: $bamfilename in folder: $target_folder"
  
  # *** Singularity processing ****
  # Need to adjust the target folder to the input folder and output of 
  # Singularity instance for each sample
  # Call the Human reference file and its index file which are softlinked above
  # Also adjust what are the Algorithm for Parliament 2 wish to run
  # I opted only for Lumpy here 
  
  singularity run --bind "$target_folder/":"/home/dnanexus/in" \
  --bind "$target_folder/":"/home/dnanexus/out" parliament2_latest.sif \
    --bam "$bamfilename" \
    --bai "$bamfilename.bai" \
    --fai "Homo_sapiens_ref38.fasta.fai" \
    -r "Homo_sapiens_ref38.fasta" --lumpy

# Remove the Singularity container once processing is complete
# It will free up storage space in the cluster
rm parliament2_latest.sif

done


