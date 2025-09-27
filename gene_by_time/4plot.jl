using DataFrames, CSV
using MendelPlots

pheno = ARGS[1]
dir = ARGS[2]

df = CSV.read("$(dir)/$(pheno)/result/$(pheno).merged.maf.txt.gz", DataFrame)
df.chr .= replace.(df.chr, r"^chr" => "")

# maf filtering
df = filter(row -> row.ref_freq > 0.01, df)

# calculate proper ystep
column_data1 = df[!, "betapval"]
min_value1 = minimum(column_data1[column_data1 .!= 0])
print(min_value1)
y_max1 = -log10(min_value1)
if y_max1 >= 20
    beta_ystep=round(y_max1/10)
    beta_ymax=1e-50
elseif y_max1 < 20
    beta_ystep=2
    beta_ymax=min_value1
end

column_data2 = df[!, "taupval"]
min_value2 = minimum(column_data2[column_data2 .!= 0])
y_max2 = -log10(min_value2)
if y_max2 >= 20
    tau_ystep=round(y_max2/10)
    tau_ymax=1e-50
elseif y_max2 < 20
    tau_ystep=2
    tau_ymax=min_value2
end

manhattan(df; outfile = "$(dir)/$(pheno)/plot/$(pheno).manhattan.betapval.png",pvalvar="betapval", ystep=beta_ystep, signifline=-log10(5e-8))
print("manhattan plot of beta done")
manhattan(df;outfile="$(dir)/$(pheno)/plot/$(pheno).manhattan.taupval.png",pvalvar="taupval", ystep=tau_ystep,signifline=-log10(5e-8))
print("manhattan plot of tau done")
qq(df;outfile="$(dir)/$(pheno)/plot/$(pheno).qq.betapval.png",pvalvar="betapval",ymax=beta_ymax)
print("QQ plot of beta done")
qq(df;outfile="$(dir)/$(pheno)/plot/$(pheno).qq.taupval.png",pvalvar="taupval",ymax=tau_ymax)
print("QQ plot of tau done")
