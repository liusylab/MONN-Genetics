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
#SBATCH --job-name=step2_${pheno}_chr1-22
#SBATCH --mem=20G
#SBATCH --output=${work_path}/bin/slurm_step2_${pheno}_chr1-22.sh
echo \"process will start at : \"
date
regenie --step 2 --pgen ./pgen_file/NIPT_glimpse.merged.chr1-22 \\ 
--threads 8 --phenoCol ${pheno} \\
--covarFile ${work_path}/input/Plink.PC1-10.47512.maternalAge.xCov.qtrans.txt \\ 
--phenoFile ${pheno_path}/${pheno}.table.txt \\ 
--bsize 1000 --bt --firth --approx \\
--pred ${work_path}/step1_fit_output_${pheno}_chr1-22_pred.list --gz \\ 
--out ${work_path}/step2_fit_output_${pheno}_chr1-22
echo \"process end at : \"
date" > ${work_path}/bin/sbatch_step2_${pheno}_chr1-22.txt
done

