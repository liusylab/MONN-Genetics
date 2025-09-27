#!/bin/bash
pheno=$1
outdir=$2

for chr in {`seq 1 22`,X}
do
    awk 'FNR!=1 { print }' $outdir/score/${pheno}.chr${chr}.* >> $outdir/result/${pheno}.chr${chr}.merged
    sed 's/^chrX/23/g' $outdir/result/${pheno}.chr${chr}.merged > $outdir/result/${pheno}.chr${chr}.merged.23
    sed 's/^chr//g' $outdir/result/${pheno}.chr${chr}.merged.23 > $outdir/result/${pheno}.chr${chr}.merged.23.nochr
    sort -k1n -k2n $outdir/result/${pheno}.chr${chr}.merged.23.nochr > $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort
    sed 's/^/chr/g' $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort > $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr
    sed 's/^chr#/#/g' $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr > $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr.final
    bgzip -f $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr.final 
    tabix -s 1 -b 2 -e 2 $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr.final.gz
    mv $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr.final.gz $outdir/result/${pheno}.chr${chr}.merged.gz
    mv $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr.final.gz.tbi $outdir/result/${pheno}.chr${chr}.merged.gz.tbi
    rm $outdir/result/${pheno}.chr${chr}.merged $outdir/result/${pheno}.chr${chr}.merged.23 $outdir/result/${pheno}.chr${chr}.merged.23.nochr $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort $outdir/result/${pheno}.chr${chr}.merged.23.nochr.sort.sort.chr
done
