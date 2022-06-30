library(reticulate)

#Four ways of incorporating Python environment in R
#1. R mark-down (not for now)

#2. Importing Python modules - use the import() function 
#   to import any Python module and call it from R.

#3. Sourcing Python scripts - source_python() function

#4. Python REPL -- interactive mode of python in R
#   repl_python()

#Sourcing Python scripts
source_python("query.py")
#call the python function with an argument of the file name
query_list <- cannabis_query("cannabis_snp.csv")

#query, get index of the cannabis
index <- which(query_list[[1]] == 'Shishkaberry_7-oaks')
#length(index) # check whether index exists
#get the snp sequence based on the index of the cannabis product
snp_sequence <- query_list[[2]][index]
snp_sequence
