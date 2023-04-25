# Analyzing the content of known repeats within "MyGenome Project" assemblies

## 1. Blast all repeats against Mygenomes and a handful of additional assemblies:
```bash
for file in `ls *fasta`; do blastn -query /project/farman_s23cs485g/MoRepeats.fasta \
-subject $file -outfmt 6 > MoRepeats.${file/_*/}.BLAST; done
```
## 2. Build a dataframe that sums the total length of select repeats in MyGenomes:
```bash
for f in MAGGY MGL Pot. Pyret_1 RETRO5 RETRO6.. MGLR_3; do for g in `ls *BLAST | \
awk -F '.' '{print $2}'`; do i=0; grep "$f\b" MoRepeats.$g.BLAST | \
awk -v var="$f" -v var2="$g" '{i+=$4} END {print var2, "\t", var, "\t", i}'; done; done |\
awk '{if(NF==2) {print $1, "\t", $2, "\t", 0} else {print $0}}' > repeats.heatmap.txt
```
## 3. Create a metadata table that lists for each genome the following:
| Genome ID | Host Plant | Repeat Density |   |   |
|-----------|------------|----------------|---|---|
|           |            |                |   |   |
