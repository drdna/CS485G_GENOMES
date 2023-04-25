# read in necessary libraries

library(ggtreeExtra)
library(ggtree)
library(treeio)
library(tidytree)
library(ggplot2)
library(ggnewscale)
library(RColorBrewer)
library(ggtext)

RepeatColors <- scale_color_gradientn(colours = rainbow(7))

# specify color vector for host plant genus
Hosts <- c("Cyperus", "Digitaria", "Eleusine", "Leersia", "Panicum", "Pennisetum", "Triticum", "Urochloa", "Zingiber")

#specify colors for repeats
repeats <- c("MAGGY", "MGL", "MGLR_3", "Pot.", "RETRO5", "RETRO6..", "Pyret1") 
  
# read in tree file
Tree <- read.tree("~/Pyricularia.nwk")

#read in metadata for tip label plotting
metadata <- read.table("~/CS485G.txt", header = T)
metadata$host <- factor(metadata$host, levels = Hosts)

#set up tip label colors to match strains IDs
LabelColors <- metadata[match(Hosts, metadata$host), "color"]

# read in repeat numbers
# columns order =  strain,  host,  #total repeat length
df_ring_heatmap <- read.table("repeats.heatmap.txt", na.strings = "NA")

# add column names to repeat dataframe
colnames(df_ring_heatmap) = c("strain", "Repeats", "Density")

# factorize by repeat category
df_ring_heatmap$Repeats <- factor(df_ring_heatmap$Repeats, levels = Repeats)

# convert repeat density to log10 values
df_ring_heatmap$Density <- log(df_ring_heatmap$Density)
                     
# include for better tree rendering                     
options(ignore.negative.edge=TRUE)
                     
#plot the tree backbone using rectangular layout
p <-ggtree(Tree, layout = "rectangular", branch.length="branch.length") + 
  new_scale_colour()

# Add colored tip labels
p1 <- p %<+% metadata +
  geom_tippoint(aes(color=host),
                alpha=0) +
  geom_tiplab(aes(color=host),
              align=TRUE,
              linetype=3,
              size=5,
              linesize=0.2,
              show.legend=FALSE) +
  scale_colour_manual(
    name="Host Genus",
    labels = c("*Cyperus*", "*Digitaria*", "*Eleusine*", "*Leersia*", "*Panicum*", "*Pennisetum*", "*Triticum*", "*Urochloa*", "*Zingiber*"),
    values=LabelColors,
    guide=guide_legend(keywidth=1,
                       keyheight=1,
                       order=1,
                       override.aes=list(size=5,alpha=1)))

# add fruits to the tree
p1 <- p1 + new_scale_fill() +
  geom_fruit(data=df_ring_heatmap, geom=geom_tile, mapping=aes(y=strain, x=Repeats, alpha=Density, fill=Repeats),
             color = "grey50", offset = 0.2, size = 0.02, pwidth=0.75) +
  scale_alpha_continuous(range=c(0, 1), breaks = c(0,2,4,6,8,10,12), guide=guide_legend(keywidth = 1, 
             keyheight = 1, order=3)) +

# add a dummy layer to force placement of the density legend last  
geom_fruit(data=df_ring_heatmap, geom=geom_bar,
           mapping=aes(y=strain, x=0, fill=Repeats),
           pwidth=0.38, 
           orientation="y", 
           stat="identity") +
  scale_fill_hue(guide=guide_legend(keywidth = 1, 
           keyheight = 1, order=2)) + theme(legend.title = element_text(face = "bold"), legend.text = element_markdown())

#pdf("PyriculariaRepeatsTree.pdf", 8.5, 11)
p1
#dev.off()