#!/bin/sh
#SBATCH --nodes=1                  
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=07-00:00:00
#SBATCH --mem=30G
#SBATCH --partition=bigmem
#SBATCH --job-name=pgen

echo "process will start at :"
date

./software/plink2 --vcf ./NIPT_glimpse.merged.chrX.vcf.gz dosage=DS --make-pgen --split-par hg38 --update-sex ./NIPT_glimpse.merged.chr1-22.psam --out ./pgen/NIPT_glimpse.merged.chrX

echo "process end at : "
date
