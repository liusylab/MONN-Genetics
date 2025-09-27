#!/bin/bash
pheno=$1
outdir=$2

for model in beta tau
do
    echo -e '#chr\tpos\tsnpid\tbetaeffect1\tbetapval1\tbetaeffect2\tbetapval2\ttaueffect1\ttaupval1\ttaueffect2\ttaupval2' > $outdir/${pheno}/result/${pheno}.merged.wald.${model}pval.txt
    awk 'FNR!=1 { print }' $outdir/${pheno}/wald/${pheno}.*.wald.${model}pval.txt >> $outdir/${pheno}/result/${pheno}.merged.wald.${model}pval.txt
    sed 's/^chrX/23/g' $outdir/${pheno}/result/${pheno}.merged.wald.${model}pval.txt > $outdir/${pheno}/result/${pheno}.merged.23.wald.${model}pval.txt
    sed 's/^chr//g' $outdir/${pheno}/result/${pheno}.merged.23.wald.${model}pval.txt > $outdir/${pheno}/result/${pheno}.merged.23.nochr.wald.${model}pval.txt
    sort -k1n -k2n $outdir/${pheno}/result/${pheno}.merged.23.nochr.wald.${model}pval.txt > $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.wald.${model}pval.txt
    sed 's/^/chr/g' $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.wald.${model}pval.txt > $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.wald.${model}pval.txt
    sed 's/^chr#/#/g' $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.wald.${model}pval.txt > $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.final.wald.${model}pval.txt
    bgzip -f $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.final.wald.${model}pval.txt 
    mv $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.final.wald.${model}pval.txt.gz $outdir/${pheno}/result/${pheno}.merged.wald.${model}pval.gz
    rm $outdir/${pheno}/result/${pheno}.merged.wald.${model}pval.txt $outdir/${pheno}/result/${pheno}.merged.23.wald.${model}pval.txt $outdir/${pheno}/result/${pheno}.merged.23.nochr.wald.${model}pval.txt $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.wald.${model}pval.txt $outdir/${pheno}/result/${pheno}.merged.23.nochr.sort.sort.chr.wald.${model}pval.txt
done
