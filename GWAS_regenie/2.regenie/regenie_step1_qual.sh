work_path=./REGENIE
pheno_path=./REGENIE/input
for pheno_file in `ls ${pheno_path}/*.table.txt` 
do
pheno_name=${pheno_file##*/}
pheno=${pheno_name%%.table.txt*}

echo "#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1-00:00:00
#SBATCH --partition=cpu
#SBATCH --job-name=step1_${pheno}_chr1-22
#SBATCH --mem=20G
#SBATCH --output=${work_path}/bin/slurm_step1_${pheno}_chr1-22.sh
echo \"process will start at : \"
date
regenie --step 1 \\
--pgen ./pgen_file/NIPT_glimpse.merged.chr1-22_qc \\ 
--threads 8 \\
--exclude ./bin/snplist_rm.txt \\
--phenoCol ${pheno} \\
--covarFile ${work_path}/input/Plink.PC1-10.47512.maternalAge.xCov.qtrans.txt \\ 
--phenoFile ${pheno_path}/${pheno}.table.txt \\ 
--bsize 1000 --bt --loocv --lowmem \\
--lowmem-prefix ${work_path}/step1_fit_output_${pheno}_chr1-22_tem \\
--out ${work_path}/step1_fit_output_${pheno}_chr1-22
echo \"process end at : \"
date" > ${work_path}/bin/sbatch_step1_${pheno}_chr1-22.txt
done

