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
./software/plink2 --vcf ./NIPT_glimpse.merged.1-22chr.vcf.gz dosage=DS --make-pgen --out ./REGENIE/pgen/_NIPT_glimpse.merged.chr1-22
echo "process end at : "
date
