import pandas as pd
from itertools import chain
import os

df = pd.read_csv("../hg38.chrom.sizes.txt", sep="\t", header=None)
df.iloc[:, 0] = df.iloc[:, 0].str[3:]
df.iloc[:, 0] = df.iloc[:, 0].replace("X", 23)
df.iloc[:, 0] = df.iloc[:, 0].replace("Y", 24)
df.iloc[:, 0] = df.iloc[:, 0].replace("Y", 24)
df[df.columns[0]] = pd.to_numeric(df[df.columns[0]])
df = df.sort_values(0, ascending=True)
df = df.iloc[0:23, :]
df.iloc[:, 0] = df.iloc[:, 0].replace(23, "X")

d = df.set_index(0).T.to_dict('list')

vcfdir = '../vcf'
covfile = '../input/baoan.RDW_CV.gestation_day.PC1-10.maternal_age.BMI.delivery_day.gestation_period.59405.cov_trait_20231204.csv'
# pheno_list = ["WBC","NEU_P","LYM_P","MON_P","EOS_P","BASO_P","NEUT","LYM","MON","EOS","BASO","RBC","HGB", "Hct","MCV","MCH","MCHC","RDW_CV","RDW","PLT","MPV","PCT","PDW","P_LCR"]
pheno_list = ["RDW"]
for pheno in pheno_list:
    shell_file = '../bin/blood_julia/1.3work.split_{pheno}_julia.sh'.format_map(vars())
    with open(shell_file, 'w+') as f2:
        fitted_null = '../input/{pheno}.null.txt'.format_map(vars())
        pvaldir = '../output/{pheno}/score'.format_map(vars())
        for chr in chain(range(1, 23), 'X'):
            for i in range(249):
                size = d[chr][0]
                l = i * 1000000 + 1
                u = (i + 1) * 1000000
                command4 = " ".join(['time julia ../bin/2.LMM.model.{pheno}.GE.jl'.format_map(vars()), vcfdir, str(chr), fitted_null, covfile, pvaldir, str(l), str(u), pheno])
                print(command4, file=f2)
                if u > size:
                    break
            # print(i)





