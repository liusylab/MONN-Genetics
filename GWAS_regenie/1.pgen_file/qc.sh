#!/bin/sh
#SBATCH --nodes=1                  
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=07-00:00:00
#SBATCH --mem=30G
#SBATCH --partition=bigmem
#SBATCH --job-name=qc
echo "process will start at :"
date
./software/plink2 --threads 8 --pfile ./NIPT_glimpse.merged.chr1-22 --maf 0.05 --mac 100 --geno 0.1 --hwe 1e-15 --snps-only --make-pgen --out ./pgen/NIPT_glimpse.merged.chr1-22_qc
