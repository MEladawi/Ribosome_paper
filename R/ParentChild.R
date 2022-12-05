
# ::'#####:::
# :'##.. ##::
# '##:::: ##:
#  ##:::: ##:
#  ##:::: ##:
# . ##:: ##::
# :. #####:::
# ::.....:::::Define the required functions-----------------------------------------------------------------------------
#````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
#simple function to rename dataframe column at a specific location
rename_col <- function(df, index, new_name) {
  col_names <- colnames(df)
  col_names[index] <- new_name
  colnames(df) <- col_names
  return(df)
}
#________________________________________________________________________________________________________________________





# :::'##:::
# :'####:::
# :.. ##:::
# ::: ##:::
# ::: ##:::
# ::: ##:::
# :'######:
# :......::load the required libraries-----------------------------------------------------------------------------------
library(readr)
library(tidyverse)
library(magrittr)
library(GO.db)
library(reshape2)
#_______________________________________________________________________________________________________________________





# :'#######::
# :##.... ##:
# ..::::: ##:
# :'#######::
# :##::::::::
# :##::::::::
# :#########:
# .........::read the GSEA result file---------------------------------------------------------------------------------
#``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
# columns should be [go_id, pathway, category]
gsea_results <- read.csv("./gsea_sig_pathways.csv")
#______________________________________________________________________________________________________________________





# :'#######::
# '##.... ##:
# ..::::: ##:
# :'#######::
# :...... ##:
# '##:::: ##:
# . #######::
# :.......:::Read the GO ancestors databases---------------------------------------------------------------------------
#``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
#get the ancestors of GO Sub-Ontologies (biological process, molecular function, & cellular component) 
#and remove the terms without ancestors
go_bp_map <- na.omit(as.data.frame(GOBPANCESTOR)) %>% rename_col(2, "go_id_parent") %>% filter(go_id_parent != "all")
go_mf_map <- na.omit(as.data.frame(GOMFANCESTOR)) %>% rename_col(2, "go_id_parent") %>% filter(go_id_parent != "all")
go_cc_map <- na.omit(as.data.frame(GOCCANCESTOR)) %>% rename_col(2, "go_id_parent") %>% filter(go_id_parent != "all")
go_all_map <- rbind(go_bp_map, go_mf_map, go_cc_map) 
#_____________________________________________________________________________________________________________________






#  ##::::::::
#  ##:::'##::
#  ##::: ##::
#  ##::: ##::
#  #########:
# ...... ##::
# :::::: ##::
# ::::::..:::Get the ancestor list of the GO terms of interest (from th GSEA result file)---------------------------
#````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
#We, then, calculate the frequency of each ancestor and retrieve its GO term
go_bp_ances_counts <- as.data.frame(table(go_bp_map[go_bp_map$go_id %in% gsea_results$go_id, 2])) %>% 
                      dplyr::rename(go_id = Var1, count=Freq) %>% 
                      mutate(freq_percent = count*100/length(go_bp_map[go_bp_map$go_id %in% gsea_results$go_id, 2]),      
                             term = AnnotationDbi::Term(as.character(go_id))) %>%
                      arrange(desc(count))
write.csv(go_bp_ances_counts, "./gp_bp_summary.csv")

go_cc_ances_counts <- as.data.frame(table(go_cc_map[go_cc_map$go_id %in% gsea_results$go_id, 2])) %>% 
                      dplyr::rename(go_id = Var1, count=Freq) %>% 
                      mutate(freq_percent = count*100/length(go_cc_map[go_cc_map$go_id %in% gsea_results$go_id, 2]),      
                             term = AnnotationDbi::Term(as.character(go_id))) %>%
                      arrange(desc(count))
write.csv(go_cc_ances_counts, "./go_cc_summary.csv")

go_mf_ances_counts <- as.data.frame(table(go_mf_map[go_mf_map$go_id %in% gsea_results$go_id, 2])) %>% 
                      dplyr::rename(go_id = Var1, count=Freq) %>% 
                      mutate(freq_percent = count*100/length(go_mf_map[go_mf_map$go_id %in% gsea_results$go_id, 2]),      
                             term = AnnotationDbi::Term(as.character(go_id))) %>%
                      arrange(desc(count))
write.csv(go_mf_ances_counts, "./go_mf_summary.csv")
#__________________________________________________________________________________________________________________








# '########:
#  ##.....::
#  ##:::::::
#  #######::
# ...... ##:
# '##::: ##:
# . ######::
# :......::::Build the truth table based on the groups of interest-------------------------------------------------
#``````````````````````````````````````````````````````````````````````````````````````````````````````````````````
target_ancestors <- read_tsv("./target_groups.tsv")
bp_truthT <- go_bp_map[go_bp_map[,2] %in% target_ancestors$go_id,] %>% 
             mutate(term = AnnotationDbi::Term(as.character(go_id_parent))) %>% 
             filter(go_id %in% gsea_results$go_id) %>% 
             acast(go_id ~ term, fun.aggregate = length)
write.csv(bp_truthT, "./bp_truthT.csv")

cc_truthT <- go_cc_map[go_cc_map[,2] %in% target_ancestors$go_id,] %>% 
             mutate(term = AnnotationDbi::Term(as.character(go_id_parent))) %>% 
             filter(go_id %in% gsea_results$go_id) %>% 
             acast(go_id ~ term, fun.aggregate = length)
write.csv(cc_truthT, "./cc_truthT.csv")

mf_truthT <- go_bp_map[go_mf_map[,2] %in% target_ancestors$go_id,] %>% 
             mutate(term = AnnotationDbi::Term(as.character(go_id_parent))) %>% 
             filter(go_id %in% gsea_results$go_id) %>% 
             acast(go_id ~ term, fun.aggregate = length)
write.csv(mf_truthT, "./mf_truthT.csv")

all_truthT <- go_all_map[go_all_map[,2] %in% target_ancestors$go_id,] %>% 
              mutate(term = AnnotationDbi::Term(as.character(go_id_parent))) %>% 
              filter(go_id %in% gsea_results$go_id) %>% 
              acast(go_id ~ term, fun.aggregate = length)
write.csv(all_truthT, "./all_truthT.csv")
#__________________________________________________________________________________________________________________
