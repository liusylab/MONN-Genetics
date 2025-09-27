import sys
import pandas as pd
from itertools import chain
import os

filedir = sys.argv[1]
model = sys.argv[2]
#model = "betapval"
#model = "taupval"
file_type = sys.argv[3]
# file_type = 'WS'
# file_type = 'BS'
p = sys.argv[4]
# p = 'p5e-8'
outfile = sys.argv[5]
juliadir = sys.argv[6]
pheno = sys.argv[7]

df = pd.read_csv("../bin/hg38.chrom.sizes.txt", sep="\t", header=None)
# print(df)
df.iloc[:, 0] = df.iloc[:, 0].str[3:]
df.iloc[:, 0] = df.iloc[:, 0].replace("X", 23)
df.iloc[:, 0] = df.iloc[:, 0].replace("Y", 24)
df.iloc[:, 0] = df.iloc[:, 0].replace("Y", 24)
df.iloc[:, 0] = pd.to_numeric(df.iloc[:, 0])
df = df.sort_values(0, ascending=True)
df = df.iloc[0:23, :]
df.iloc[:, 0] = df.iloc[:, 0].replace(23, "X")
# print(df)

d = df.set_index(0).T.to_dict('list')
# print(d)
# print(d[7])

vcfdir = '../vcf'
covfile = '../input/baoan.RDW_CV.gestation_day.PC1-10.maternal_age.BMI.delivery_day.gestation_period.59405.cov_trait_20231204.csv'
pvaldir = '../output/{pheno}/wald'.format_map(vars())
scorepdir = '../output/{pheno}/score'.format_map(vars())

with open(outfile, 'w+') as f: #！
    for chr in chain(range(1, 23), 'X'):
        print(chr)
        size = d[chr][0]
        # print(size)
        file = filedir + str(chr) + '.trajgwas.' + file_type + '.' + p + '.gz'
        print(file)
        if os.path.exists(file):
            df = pd.read_csv(file, sep="\t", compression='gzip', header=None, names=['chr', 'pos', 'snpid', 'betapval', 'taupval', 'jointpval'])
            # print(df)
            data = df

            for i in range(249):
                l = i * 1000000 + 1
                # print(type(l))
                u = (i + 1) * 1000000
                if (data.pos[(data['pos'] >= l) & (data['pos'] <= u)]).any():
                    print(data.pos[(data['pos'] >= l) & (data['pos'] <= u)])
                    print(l, u)
                    command1 = " ".join(['time julia ' + juliadir, vcfdir, str(chr), covfile, pvaldir, scorepdir, str(l), str(u), model, pheno])
                    # print(command1)
                    print(command1, file=f)
                    # if u > size:
                    #    break