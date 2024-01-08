library(doParallel)

custom_rarefy <- function(TBL=TBL, bgc_name=bgc_name, n_cores=n_cores) {

  registerDoParallel(n_cores)

  TBL_bgc_wide <- TBL %>% 
                  filter(bgc %in% !!(bgc_name)) %>%
                  ungroup %>%
                  select(sample, cluster_id, abund) %>%
                  mutate(abund = round(abund, 0)) %>%
                  pivot_wider(names_from = cluster_id, 
                              values_from = abund, 
                              values_fill = 0) %>%
                  column_to_rownames("sample")
  
  sample_min <- rowSums(TBL_bgc_wide) %>% min()
  sample_max <- rowSums(TBL_bgc_wide) %>% max()
  step <- round(sample_max/10,0)
  
  if (step >= 2) { 
   
    TBL_bgc_wide_rare <- foreach(i = rownames(TBL_bgc_wide), .inorder = F) %dopar% {
      rare_output <- rarecurve(x = TBL_bgc_wide[i,], step = step)
      return(rare_output)
    }

    TBL_bgc_wide_rare_mtx <- sapply(TBL_bgc_wide_rare, "[[", 1) %>%
                             do.call("bind_rows", .) %>%
                             as.data.frame

    rownames(TBL_bgc_wide_rare_mtx) <- rownames(TBL_bgc_wide)
  
    TBL_bgc_wide_rare_long <- TBL_bgc_wide_rare_mtx %>%
                              as.data.frame %>%
                              rownames_to_column("sample") %>%
                              filter(!grepl(pattern = ".se", x = sample)) %>%
                              pivot_longer(data = ., names_to = "iteration", 
                                           values_to = "richness", 
                                           cols = colnames(TBL_bgc_wide_rare_mtx)) %>%
                              mutate(iteration = sub(x = iteration, pattern = "^N", replacement = "") %>% as.numeric ) %>% 
                              filter(is.na(richness) == F) %>%
                              mutate(bgc = bgc_name)  

    TBL_bgc_wide_rare_coords <- TBL_bgc_wide_rare_long %>%
                                group_by(sample) %>%
                                summarize(max_richness = max(richness),
                                          max_interation = max(iteration))  %>%
                                mutate(bgc = bgc_name)  

    TBL_bgc_wide_rare_coords$sample <- factor(TBL_bgc_wide_rare_coords$sample, 
                                              levels = unique(TBL_bgc_wide_rare_coords$sample))
  
  
    output <- list(rare = TBL_bgc_wide_rare_long, coords = TBL_bgc_wide_rare_coords)
    return(output)
  }
}