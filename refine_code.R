setwd("~/Malavika/sbdsc/exercises/DW1")

#Load data in RStudio

refine_original <- read.csv("refine_original.csv", header = TRUE)
refine <- refine_original

#Packages used tidyr, dplyr, dummies

library(tidyr)
library(dplyr)
library(dummies)

#1. Clean up brand names

#identified all misspellings using unique 
unique(refine$company)

phillips <- c("Phillips", "philips", "phllips", "phillps", "phillipS","fillips", "phlips")
akzo <- c("ak zo", "akz0", "akzo", "Akzo", "AKZO")
vanhouten <- c("Van Houten", "van Houten", "van houten")
unilever <- c("unilever",   "Unilever","unilver")

for (i in 1: nrow(refine)){
  if (refine$company[i] %in% phillips) {  
      refine$company[i] <- "phillips"
  }
  else if (refine$company[i] %in% akzo) {  
    refine$company[i] <- "akzo"
  }
  else if (refine$company[i] %in% vanhouten) {  
    refine$company[i] <- "van_houten"
  }
  else if (refine$company[i] %in% unilever) {  
    refine$company[i] <- "unilever"
  }
}

#Separate product code and number

 refine <- separate(refine,Product.code...number, c("product_code", "product_number"), sep = "-")
 
#Add product categories 
 
 p_cat <- cbind(c("p","v","x","q"), c("smartphone", "tv","laptop","tablet"))
 p_cat <- tbl_df(p_cat)
 names(p_cat) <- c("product_code", "product_category")
 refine <- left_join(refine, p_cat, by = "product_code")
 
#Add full address for geocoding
 
 refine <- unite(refine, "full_address",4,5,6, sep = ",  ")
 
#Create dummy variables for company and product category
 
 company <- dummy(refine$company, sep = "_")
 refine <- cbind(refine, company)
 prod_cat <- dummy(refine$product_category, sep = "_")
 refine <- cbind(refine, prod_cat)
 
#Creating csv file with clean data
 
 write.csv(refine, file = "refine_clean.csv" )
 
 