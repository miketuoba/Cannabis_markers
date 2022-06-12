# 7 SNPs & Terpene Analysis - Hops
# 2022-02, Oceanne.W

library("ggdendro")
library("factoextra")
library("stringr")
library("tidyverse")
library("dendextend")

#Change directory to file saved location
setwd("/Users/Oceanne.W/Desktop/Terpene PCA/Terpene PCA project")
#Read in csv file with n.a. replaced by "" into a table
SNP_YC_raw = as.data.frame(read.csv(file = "snp genotype YC (mod).csv", 
                                 TRUE, ",", na.strings = ""))
SNP_YC_score <- SNP_YC_raw

for(y in seq(1,nrow(SNP_YC_score),1)){
  # Regex match groups to extract "A" and "C" from "A/C"
  matches <- str_match(SNP_YC_score[y,]["alleles"], "(.)/(.)")
  c1 <- matches[2]
  c2 <- matches[3]
  temp <- SNP_YC_score[y,-c(1,2)]
  # i.e. Homozygous AA assign score -1
  temp[temp == c1] = -1
  # CC assign 1
  temp[temp == c2] = 1
  # Heterozygous assigns 0
  temp[temp != "1" & temp != "-1"] = 0
  SNP_YC_score[y, -c(1,2)] <- temp
}

SNP_YC_score <- SNP_YC_score[-c(2)]
SNP_YC_scoreT <- data.frame(t(SNP_YC_score[-1]))
colnames(SNP_YC_scoreT) <- SNP_YC_score[,1]

set.seed(55)
#Plot dendrogram of YC 
SNP_YC_dist <- dist(SNP_YC_scoreT, "euclidean")
hcSNP_YC <- hclust(SNP_YC_dist, "average")
hcdSNP_YC <- as.dendrogram(hcSNP_YC) %>%
  raise.dendrogram (0.2) %>% 
  set("branches_lwd", 0.3) %>%
  set("labels_cex", 0.3)

ggSNP_YC <- ggplot(hcdSNP_YC) + ylim(-1, 3)
ggsave(ggSNP_YC, file="out3.pdf", width=20, height=4, dpi=300)
ggSNP_YC

#Plot tanglegram
png("tanglegram.pdf", width=11, height=8.5, units = "in", res = 300)
#New canvas
dev.new(width=11, height=11, unit="in")
tanglegram(hcSNP_YC,hcYC, 
           sort = TRUE, common_subtrees_color_lines = FALSE, 
           highlight_distinct_edges  = FALSE, 
           highlight_branches_lwd = FALSE,
           main_left = "Genotype",
           main_right = "Terpenes",
           margin_inner = 6.5)
#dev.off()
