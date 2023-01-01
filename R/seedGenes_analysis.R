library(tidyverse)
library(reshape2)

#read the files with the lists of the seed (Ribosomal) genes
seed_genes <- 
  list(
    up_regulated = read.csv("seed_genes_up.csv", row.names = 1),
    down_regulated = read.csv("seed_genes_down.csv", row.names = 1),
    nonSig = read.csv("seed_genes_non.csv", row.names = 1)
)

#load the normalized genes expression data
nData <- read.csv("nData.csv", row.names = 1)


for (current_group in names(seed_genes))
{
  current_seeds <- seed_genes[[current_group]]
  
  n_rows <- length(nData[,1])
  n_cols <- length(current_seeds)
  genes <- rownames(nData)
    
  p_val <- as.data.frame(matrix(nrow = n_rows, ncol = n_cols))
  
  r_val <- as.data.frame(matrix(nrow = n_rows, ncol = n_cols))
  
  r_val_sig <- as.data.frame(matrix(data = 0, nrow = n_rows, ncol = n_cols), row.names = genes) %>% `colnames<-`(current_seeds)
  r_neg_val <- as.data.frame(matrix(data = 0, nrow = n_rows, ncol = n_cols), row.names = genes) %>% `colnames<-`(current_seeds)
  r_pos_val <- as.data.frame(matrix(data = 0, nrow = n_rows, ncol = n_cols), row.names = genes) %>% `colnames<-`(current_seeds)
  
  
  for (gene in genes)
  {
    for (current_seedGene in current_seeds)
    {
      cor <- cor.test(nData[gene,], nData[current_seedGene,], method = "pearson")
      p_val[gene, current_seedGene] <- cor$p.value
      r_val[gene, current_seedGene] <- cor$estimate
    }
  }
  
  #filter the r values using the p < 0.05
  r_val_sig[p_val<0.05] <- r_val[p_val<0.05]
  write.csv(r_val_sig, paste0("r_sig_", current_group,".csv"), row.names = rownames(nData), col.names = current_seeds)
  
  #save the negative and positive, significant r-values
  r_neg_val[r_val_sig<0] <- r_val_sig[r_val_sig<0]
  r_pos_val[r_val_sig>0] <- r_val_sig[r_val_sig>0]
  write.csv(r_neg_val, paste0("r_sig_neg_", current_group,".csv"))
  write.csv(r_pos_val, paste0("r_sig_pos_", current_group,".csv"))
  
  #calculate the number of genes that are positively and negatively correlated with each seed gene
  r_neg_count <- as.data.frame(t(colSums(r_neg_val != 0))) %>% `colnames<-`(current_seeds)
  r_pos_count <- as.data.frame(t(colSums(r_pos_val != 0))) %>% `colnames<-`(current_seeds)
  
  write.csv(r_neg_val, paste0("r_sig_neg_count_", current_group,".csv"))
  write.csv(r_pos_val, paste0("r_sig_pos_count_", current_group,".csv"))
}
