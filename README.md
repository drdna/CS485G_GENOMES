# Analyzing the content of known repeats within "MyGenome Project" assemblies

## 1. Use the MEGA-X program to build a tree based on the genetic distances between isolates

## 2. Export the tree as a text file:
```bash
(((((((((((((JA119:6,JA110:5):6,JA108:5):4,JA118:2):500,JA121:585):226,JA109:597):976,U276:2399):1124,(U270:3766,(T6:1250,T21:1508):525):1539):534,JA174:2084):303,JA158:2502):906,T29:3893):45785,(RN1:42154,(PmJA115:2973,JA171:-640):36140):11131):2657,(CD86:28728,(DsLIZ:2934,JA125:-1036):26840):27698):1184,Pm1:56414,(CrA8401:70532,Cr9010:70452):43950);
```
The tree file is named: [Pyricularia.nwk](/Pyricularia.nwk).
## 3. Blast all repeats against Mygenomes and a handful of additional assemblies:
```bash
for file in `ls *fasta`; do blastn -query /project/farman_s23cs485g/MoRepeats.fasta \
-subject $file -outfmt 6 > MoRepeats.${file/_*/}.BLAST; done
```
## 4. Build a dataframe that sums the total length of select repeats in MyGenomes:
```bash
for f in MAGGY MGL Pot. Pyret_1 RETRO5 RETRO6.. MGLR_3; do for g in `ls *BLAST | \
awk -F '.' '{print $2}'`; do i=0; grep "$f\b" MoRepeats.$g.BLAST | \
awk -v var="$f" -v var2="$g" '{i+=$4} END {print var2, "\t", var, "\t", i}'; done; done |\
awk '{if(NF==2) {print $1, "\t", $2, "\t", 0} else {print $0}}' > repeats.heatmap.txt
```
This creates a "repeats" dataframe with the following format:
| Genome ID | Repeat ID | Repeat Density |
|-----------|------------|---------------|
|  JA108    |  Urochloa  |    13214      |

The repeats dataframe is named: [repeats.heatmap.txt](/repeats.heatmap.txt)


## 5. Create a metadata table that lists each strain's host plant:
We also include the color that corresponds to each host. 
| Genome ID | Host Plant |  Color  |
|-----------|------------|---------|
|  JA108    |  Urochloa  | yellow4 |

The metadata table is named: [CS485G.txt](/CS485G.txt)

## 6. Import the three datafiles into RStudio for plotting using the ggtree program
The specific code used to generate the plots is named [CS485G_Tree.R](/CS485G_Tree.R) and will produce the following tree:
![PyriculariaRepeatsTree.pdf](/PyriculariaRepeatsTree.pdf)

