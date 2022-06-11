#Step 1: Data clean-up

#import some packages
lapply(c("vegan","ape","ggdendro","seqinr",
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

#Correspond each row with the correct cannabis sample and company
snp <- snp %>% mutate(Sample = cannabis_file$Sample, Company = cannabis_file$Company, 
                      .before = colnames(snp)[1])
View(snp)

#Step 2: Data analysis
#Step 3: Data presentation