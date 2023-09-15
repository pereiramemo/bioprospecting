library(doParallel)

custom_rarefy <- function(TBL=TBL, bgc = bgc, n_cores = n_cores) {

  registerDoParallel(n_cores)

  TBL_bgc_wide <- TBL %>% filter(bgc == bgc) %>%
                  ungroup %>%
                  select(sample, cluster_id, abund) %>%
                  mutate(abund = round(abund, 0)) %>%
                  pivot_wider(names_from = cluster_id, 
                              values_from = abund, 
                              values_fill = 0) %>%
                  column_to_rownames("sample")
  
  sample_min <- rowSums(TBL_bgc_wide) %>% min()
  sample_max <- rowSums(TBL_bgc_wide) %>% max()
  step <- round(sample_max/15,0)
  
  TBL_bgc_wide_rare <- foreach(i = rownames(TBL_bgc_wide), .inorder = T) %dopar% {
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
                             filter(is.na(richness) == F)

  TBL_bgc_wide_rare_coords <- TBL_bgc_wide_rare_long %>%
                                group_by(sample) %>%
                                summarize(max_richness = max(richness),
                                          max_interation = max(iteration))

  TBL_bgc_wide_rare_coords$sample <- factor(TBL_bgc_wide_rare_coords$sample, 
                                           levels = unique(TBL_bgc_wide_rare_coords$sample))
  
  output <- list(rare = TBL_bgc_wide_rare_long, coords = TBL_bgc_wide_rare_coords)
  return(output)


}