#!/bin/bash
pheno=$1
outdir=$2

# betapvale
#echo -e '#chr\tpos\tsnpid\tbetapval\ttaupval\tjointpval' > $outdir/result/${pheno}.trajgwas.BS.p5e-8
for chr in {`seq 1 22`,X}
do
	echo -e '#chr\tpos\tsnpid\tbetapval\ttaupval\tjointpval' > $outdir/result/${pheno}.chr${chr}.trajgwas.BS.p5e-8
	less $outdir/result/${pheno}.chr${chr}.merged.gz | awk '{if ($4<5e-8) print $0}' > $outdir/result/${pheno}.chr${chr}.trajgwas.BS.p5e-8
	bgzip -f $outdir/result/${pheno}.chr${chr}.trajgwas.BS.p5e-8
done

# taupvalue
for chr in {`seq 1 22`,X}
do
	echo -e '#chr\tpos\tsnpid\tbetapval\ttaupval\tjointpval' > $outdir/result/${pheno}.chr${chr}.trajgwas.WS.p5e-8
	less $outdir/result/${pheno}.chr${chr}.merged.gz | awk '{if ($5<5e-8) print $0}' > $outdir/result/${pheno}.chr${chr}.trajgwas.WS.p5e-8
	bgzip -f $outdir/result/${pheno}.chr${chr}.trajgwas.WS.p5e-8
done
