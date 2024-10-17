library(ape)
get_F = function(tree_lists, n, k, N, temp_folder) {
  # temp_folder: a unique folder for this worker
  
  # Ensure the temporary folder exists
  dir.create(temp_folder, recursive = TRUE, showWarnings = FALSE)
  
  for (i in 1:length(tree_lists)) {
    write.table(tree_lists[[i]], 
                file.path(temp_folder, paste0("group_", i, ".txt")),
                col.names = F, row.names = F,
                quote = F)
  }
  
  # Use temp_folder paths for mean trees and distances
  # Mean Trees (assuming your external script uses the temp_folder)
  mean_files = list.files(file.path(temp_folder, "mean_trees"), 
                          pattern = "_mean.txt",
                          full.names = T)
  
  mean_trees = list()
  for (i in 1:k) {
    temp = read.tree(mean_files[i])
    mean_trees[[i]] = temp
  }
  
  # Distances
  dist_files_between = list.files(file.path(temp_folder, "distances"),
                                  pattern = "dis.txt",
                                  full.names = T)
  dist_files_within = list.files(file.path(temp_folder, "distances"),
                                 pattern = "sep.txt",
                                 full.names = T)
  
  dist_between = c()
  dist_within = list()
  
  for (i in 1:k) {
    temp_b = as.numeric(read.table(dist_files_between[i]))
    temp_w = read.table(dist_files_within[i])
    
    dist_between = c(dist_between, temp_b)
    dist_within[[i]] = temp_w
  }
  
  # F statistics
  numerator = ( sum(n * dist_between^2) / (k - 1) )
  denominator = 0
  for (i in 1:k) {
    temp = sum(dist_within[[i]]^2)
    denominator = denominator + temp
  }
  denominator = denominator / (N - k)
  
  return (numerator / denominator)
}


tree_files = list.files("./samples_tree",
                        pattern = ".txt",
                        full.names = T)
k = length(tree_files)
n = c()


for (i in 1:k){
  # files = list.files("./samples_tree",
  #                    pattern = ".txt",
  #                    full.names = T)
  temp = readLines(tree_files[i])
  n = c(n, length(temp))
  TLs[[i]] = temp
  # TLs[[i]] = temp
}
N = sum(n)


start_time <- Sys.time()
F_obs = get_F(TLs,n,k,N)
end_time <- Sys.time()
print(end_time - start_time)

all_trees = readLines("./samples_tree/all_tree.txt")
# sample(all_trees)

set.seed(123) # for reproducibility
n_perm <- 10





library(parallel)

n_cores <- detectCores() - 1  # Number of cores
cl <- makeCluster(n_cores)  # Create a cluster

# Export necessary variables and functions
clusterExport(cl, c("all_trees", "n", "k", "N", "get_F"))

# Parallelized permutation process
perm_stats <- parLapply(cl, 1:n_perm, function(i) {
  temp_folder <- tempfile()  # Unique temporary folder for this iteration
  
  # Shuffle the trees
  shuffled_tree <- sample(all_trees)
  
  start_pos <- 1
  n_cum <- cumsum(n)
  tree_lists_temp <- list()
  
  for (j in 1:k) {
    perm_temp <- shuffled_tree[start_pos:n_cum[j]]
    start_pos <- start_pos + n[j]
    tree_lists_temp[[j]] <- perm_temp
  }
  
  # Call get_F with the unique temp_folder
  result <- get_F(tree_lists_temp, n, k, N, temp_folder)
  
  # Clean up the temporary directory (optional)
  unlink(temp_folder, recursive = TRUE)
  
  return(result)
})

# Convert perm_stats list to a numeric vector
perm_stats <- unlist(perm_stats)

# Stop the cluster
stopCluster(cl)

# Calculate p-value
p_value <- mean(perm_stats >= F_obs)
print(paste("P-value:", p_value))
