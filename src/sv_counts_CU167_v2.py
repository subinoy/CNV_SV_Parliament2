# This script counts the number of INS, DEL, DUP and BND
# from the list of processed SV files 
import os
import gzip

base_dir = "/home/sb4715/PSEN1_Manta/June_28"
vcf_list_file = "diploid_167_sample.txt"

output_file = "variant_counts_167.txt"
with open(output_file, "w") as output:
    output.write("Sample File: Total Variants, INS, DEL, DUP, BND\n")

def count_variant_type(vcf_path, variant_type):
    with gzip.open(vcf_path, "rt") as vcf:
        count = 0
        for line in vcf:
            if line.startswith("#"):
                continue
            fields = line.strip().split("\t")
            info = fields[7]
            if f"SVTYPE={variant_type}" in info:
                count += 1
        return count

with open(vcf_list_file, "r") as vcf_list:
    for vcf_file_path in vcf_list:
        vcf_file_relpath = vcf_file_path.strip()
        vcf_file = os.path.join(base_dir, vcf_file_relpath)

        print(f"Processing file: {vcf_file}")

        # Extract sample name from the file path
        sample_name = os.path.basename(os.path.dirname(vcf_file))
        vcf_file_name = os.path.basename(vcf_file)

        # Count the number of total variants in the VCF file
        total_variants = 0
        with gzip.open(vcf_file, "rt") as vcf:
            for line in vcf:
                if not line.startswith("#"):
                    total_variants += 1

        # Count the occurrences of INS, DEL, DUP, and BND variants in the VCF file
        ins_count = count_variant_type(vcf_file, "INS")
        del_count = count_variant_type(vcf_file, "DEL")
        dup_count = count_variant_type(vcf_file, "DUP")
        bnd_count = count_variant_type(vcf_file, "BND")

        # Write the results to the output file
        with open(output_file, "a") as output:
            output.write(f"{sample_name}/{vcf_file_name}: {total_variants}, {ins_count}, {del_count}, {dup_count}, {bnd_count}\n")
