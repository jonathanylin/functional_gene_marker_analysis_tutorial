#### this script uses the R package 'taxize' to extract NCBI taxon IDs from genbank accession numbers, and then uses the taxon IDs to assign and format taxonomy strings for each sequence in the Greengenes format.
#### written by Jonathan Lin @ UC Davis
#### see wiki in https://github.com/jonathanylin/functional_gene_marker_analysis_tutorial/wiki for more information

library(taxize)
library(stringr)

#set working directory and load file with accession numbers
setwd("/home/rodrigues-lab/Desktop/Termite_Urec_Project/Urec_taxonomy")
a_num <- read.table("Urec_accession_numbers.txt")

#add columns to the dataframe for taxon ID and each taxonomic level
a_num$entrez_ID <- NA
a_num$kingdom <- NA
a_num$phylum <- NA
a_num$class <- NA
a_num$order <- NA
a_num$family <- NA
a_num$genus <- NA
a_num$species <- NA

#use the genbank2uid() command in taxize to search through each genbank number and match with corresponding NCBI taxon number
#potential bottleneck: this step takes a very long time. Takes ~ 3+ hours to iterate through 25,000 sequences
for (i in a_num$V1) {
  try(entrezID <- genbank2uid(id = i))
  a_num$entrez_ID[which(a_num$V1 == i)] = entrezID[1][1][[1]]
  }

#save table with taxon IDs added
write.table(a_num, "a_with_entrezID.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

#use the classification() command in taxize to match each taxon ID with its corresponding taxonomy, with the Greengenes prefix (e.g. "k__") for each sequence
#this step is much faster than the last one, but still takes ~ 1.5 hours to iterate through 25,000 sequences
for (i in a_num$entrez_ID) {
  taxa <- classification(i, db = "ncbi")
  split <- str_split_fixed(taxa[[i]]$name[which(taxa[[i]]$rank == "species")], " ", n = 2)
  a_num$kingdom[which(a_num$entrez_ID == i)] = paste("k__", taxa[[i]]$name[which(taxa[[i]]$rank == "superkingdom")], sep = "")
  a_num$phylum[which(a_num$entrez_ID == i)] = paste("p__", taxa[[i]]$name[which(taxa[[i]]$rank == "phylum")], sep = "")
  a_num$class[which(a_num$entrez_ID == i)] = paste("c__", taxa[[i]]$name[which(taxa[[i]]$rank == "class")], sep = "")
  a_num$order[which(a_num$entrez_ID == i)] = paste("o__", taxa[[i]]$name[which(taxa[[i]]$rank == "order")], sep = "")
  a_num$family[which(a_num$entrez_ID == i)] = paste("f__", taxa[[i]]$name[which(taxa[[i]]$rank == "family")], sep = "")
  a_num$genus[which(a_num$entrez_ID == i)] = paste("g__", taxa[[i]]$name[which(taxa[[i]]$rank == "genus")], sep = "")
  a_num$species[which(a_num$entrez_ID == i)] = paste("s__", split[,2], sep = "")
  }

#save table with taxonomy added
write.table(a_num, "a_with_taxonomy.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

#concatenate taxonomic levels into a single string separated by a semicolon and a space
a_num$taxonomy <- paste(a_num$kingdom, a_num$phylum, a_num$class,
                        a_num$order, a_num$family, a_num$genus,
                        a_num$species, sep = "; ")

#use dplyr to subset only the accession numbers and concatenated taxonomy strings
library(dplyr)
a_with_taxonomy <- select(a_num, V1, taxonomy)
head(a_with_taxonomy)

#write taxonomy table as tab-separated file, without row or col names
write.table(a_with_taxonomy, "Urec_taxonomy_FINAL.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
