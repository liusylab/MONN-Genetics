using DataFrames, CSV
using Statistics
using TrajGWAS
using WiSER
using LinearAlgebra
using Serialization
BLAS.set_num_threads(1)

vcfdir = ARGS[1]
chr = ARGS[2]
covfile = ARGS[3] # covariate file (csv) with one header line. One column should be the longitudinal phenotype
pvaldir = ARGS[4] # output file path for the gwas p-values
scorepdir = ARGS[5]
l = ARGS[6] # lower limit of chunck
u = ARGS[7] # upper limit of chunck
model = ARGS[8]
# model = ":betapval"
# model = ":taupval"
pheno = ARGS[9]

pheno_data = CSV.read(covfile, DataFrame)
# VCF file was seprated into 1000000 chunks in advance
vcffile = vcfdir * "/baoan_NIPT_glimpse_70608.merged.chr$(chr).59405.$(l)-$(u)" # VCF file without the .vcf extension
pvalfile = pvaldir * "/$(pheno).chr$(chr).$(l)-$(u).wald.$(model).txt"
scorefile = scorepdir * "/$(pheno).chr$(chr).$(l)-$(u).txt"
scorepvals = CSV.read(scorefile, DataFrame) # results of score test GWAS
snpinds = findall(scorepvals[!,"$model"] .< 5e-8)  # Sort snps with score test p-values < 5e-8 and find top 10 SNPs

# Re-do LRT on top hits
trajgwas(@formula(RDW ~ 1 + Age + BMI + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10 + gestation_day), # mean formula (β) for the null model
    @formula(RDW ~ 1), # random effects formula (γ) for the model
    @formula(RDW ~ 1 + Age + BMI + gestation_day), # within-subject variance formula (τ) for the null model
    :nipt_id, # : column name of sample ID in covfile
    pheno_data, # covfile
    vcffile;  # VCF file
    geneticformat = "VCF", # Type of file used for the genetic analysis
    vcftype = :DS, # :DS for dosage
    pvalfile,
    snpinds = snpinds, # SNP indices for bed/vcf file
    test = :wald,
    testformula=@formula(y ~ snp + snp & gestation_day))
