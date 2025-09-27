#!/bin/bash

sample=../input/baoan_vcf_sample.59405.check.txt
outdir=../vcf

for chr in {`seq 1 22`,X}
do
    file=../baoan_NIPT_glimpse_70608.merged.chr${chr}.vcf.gz
    echo "#!/bin/bash\n#SBATCH -N 1\n#SBATCH -p bigdata" > ../bin/split_vcf/1.1vcf_split.work.${chr}.sh
    echo "module load bcftools" >> ../bin/split_vcf/1.1vcf_split.work.${chr}.sh
    echo "bcftools view -Oz -S $sample $file --threads 24 > $outdir/baoan_NIPT_glimpse_70608.merged.chr${chr}.59405.vcf.gz" >> ../bin/split_vcf/1.1vcf_split.work.${chr}.sh
    echo "bcftools index $outdir/baoan_NIPT_glimpse_70608.merged.chr${chr}.59405.vcf.gz --threads 24" >> ../bin/split_vcf/1.1vcf_split.work.${chr}.sh
done

split -l 1 -d -a 2 ../bin/split_vcf/1.1vcf_split.work.${chr}.sh ../bin/split_vcf/1.1vcf_split.work
