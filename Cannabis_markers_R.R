#Step 1: Data clean-up

#import some packages
lapply(c("vegan","ape","ggdendro","seqinr", "factoextra","dendextend",
         "Biostrings", "tidyverse", "readr", "readxl", "stringr")
          ,library, character.only = TRUE)

#read the excel file
cannabis_file <- read_excel("Cannabis info.xlsx")

#split the 16-base pair SNP into 16 single bases
#and create a data frame out of them
snp <- as.data.frame(
  str_split_fixed(cannabis_file$SNPS, 
                  pattern = "", n = 16))

#assign each column with the names of SNPS Assays used
colnames(snp) <- cannabis_file$`Snps Assay`[1:16]

#Create a new row with corresponding cannabis sample and company
snp <- snp %>% mutate(Sample = paste(cannabis_file$Sample, cannabis_file$Company, sep = "_"), 
                      .before = colnames(snp)[1])
View(snp)

#Step 2: Data analysis
# a for-loop to read in each column of snp's
for(x in seq(2,ncol(snp),1)){
  temp <- snp[,x] # take a column of snp's as a vector
  # check if R|Y|W|M is in the vector
  if (!is.na(match("R", temp))){
    c1 <- "G"
    c2 <- "A"
  }
  else if (!is.na(match("Y", temp))){
    c1 <- "C"
    c2 <- "T"
  }
  else if (!is.na(match("W", temp))){
    c1 <- "A"
    c2 <- "T"
  }
  else if (!is.na(match("M", temp))){
    c1 <- "A"
    c2 <- "C"
  }
  #Assign homologous alleles as 1 or -1
  temp[temp == c1] = -1
  temp[temp == c2] = 1
  #Assign heterozygous alleles as 0
  temp[temp != "1" & temp != "-1"] = 0
  snp[,x] <- temp # store the scores back to the column vector
}

View(snp)

set.seed(53)
#Plot dendrogram
SNP_dist <- dist(snp, "euclidean")
hcSNP <- hclust(SNP_dist, "average")
hcdSNP <- as.dendrogram(hcSNP) %>%
  raise.dendrogram (0.2) %>% 
  set("branches_lwd", 0.3) %>%
  set("labels_cex", 0.3)

ggSNP <- ggplot(hcdSNP) + ylim(-1, 3)
ggsave(ggSNP, file="out3.pdf", width=20, height=4, dpi=300)
ggSNP

#Plot tanglegram (unused for now)
#png("tanglegram.pdf", width=11, height=8.5, units = "in", res = 300)
#New canvas
#dev.new(width=11, height=11, unit="in")
#tanglegram(hcSNP_YC,hcYC, 
#           sort = TRUE, common_subtrees_color_lines = FALSE, 
#           highlight_distinct_edges  = FALSE, 
#           highlight_branches_lwd = FALSE,
#           main_left = "Genotype",
#           main_right = "Terpenes",
#           margin_inner = 6.5)


#Step 3: Data presentation