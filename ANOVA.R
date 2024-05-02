library(ape)

get_F = function(tree_lists, n, k, N) {
  # tree_lists: lists of trees in k groups
  
  for (i in 1:length(tree_lists)) {
    write.table(tree_lists[[i]], 
                paste0("./samples_tree/group_", 
                       i, ".txt"),
                col.names = F, row.names = F,
                quote = F)
  }
  
  source("./get_mean.R")
  source("./get_dist.R")
  
  # Mean Trees
  mean_files = list.files("./mean_trees", 
                          pattern = "_mean.txt",
                          full.names = T)
  
  mean_trees = list()
  for (i in 1:k) {
    temp = read.tree(mean_files[i])
    mean_trees[[i]] = temp
  }
  
  # Distances
  dist_files_between = list.files("./distances",
                                  pattern = "dis.txt",
                                  full.names = T)
  dist_files_within = list.files("./distances",
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

n = c() # n_i
for (file in tree_files){
  n = c(n, length(readLines(file)))
}

k = length(n)
N = sum(n)

TLs = list()

for (i in 1:k){
  files = list.files("./samples_tree",
                     pattern = ".txt",
                     full.names = T)
  temp = readLines(files[i])
  TLs[[i]] = temp
}

# get_F(TLs)
start_time <- Sys.time()
F_obs = get_F(TLs)
end_time <- Sys.time()
print(end_time - start_time)

all_trees = readLines("./samples_tree/all_tree")
# sample(all_trees)

set.seed(123) # for reproducibility
n_perm <- 10
perm_stats <- numeric(n_perm)

for (i in 1:n_perm) {
  print(i)
  # Shuffle data
  shuffled_tree <- sample(all_trees)
  
  start_pos = 1
  n_cum = cumsum(n)
  tree_lists_temp = list()
  for (i in 1:k){
    perm_temp = shuffled_tree[start_pos:n_cum[i]]
    start_pos = start_pos + n[i]
    tree_lists_temp[[i]] = perm_temp
  }

  perm_stats[i] <- get_F(tree_lists_temp)
}

p_value <- mean(perm_stats >= F_obs)
print(paste("P-value:", p_value))
