import pandas as pd

#read in a file as parameter
def cannabis_query(file):
  file_cannabis = pd.read_csv(file) # open the file
  col_names = list(file_cannabis.columns) # get col_names as list
  # get the contents of first col (samples) as a tuple
  cannabis_samples = tuple(file_cannabis[col_names[0]])
  # get the contents of second col (snps) as a tuple
  snps = tuple(file_cannabis[col_names[1]])
  #put two tuples in a list, simultating an immutable database
  db = [cannabis_name, snps] 
  return db
