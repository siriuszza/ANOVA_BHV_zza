# Example data
group1 <- c(20, 21, 19, 22, 20)
group2 <- c(30, 31, 29, 32, 30)
group3 <- c(40, 41, 39, 42, 40)

data <- c(group1, group2, group3)
k = 3



F_obs = get_F(data, group1, group2, group3)

# Permutation test
set.seed(123) # for reproducibility
n_perm <- 10000
perm_stats <- numeric(n_perm)

for (i in 1:n_perm) {
  # Shuffle data
  shuffled_data <- sample(data)
  
  # Compute test statistic for permuted data
  perm_group1 <- shuffled_data[1:length(group1)]
  perm_group2 <- shuffled_data[(length(group1) + 1):(length(group1) + length(group2))]
  perm_group3 <- shuffled_data[(length(group1) + length(group2) + 1):length(data)]
  
  perm_stats[i] <- get_F(data, 
                         perm_group1,
                         perm_group2,
                         perm_group3)
}

# Calculate p-value
p_value <- mean(perm_stats >= obs_stat)
print(paste("P-value:", p_value))


get_F = function(data, g1, g2, g3) {
  N = length(data)
  n = c(length(g1), length(g2), length(g3))
  
  means = c(mean(g1), mean(g2), mean(g3))
  mean_all = mean(data)
  
  SST = sum(n * (means - mean_all)^2)
  MST = SST / (k-1)
  
  SSE = sum((g1 - means[1])^2) + 
    sum((g2 - means[2])^2) + 
    sum((g3 - means[3])^2)
  MSE = SSE / (N - k)
  
  return(MST / MSE)
}




library(ape)
tree1 <- read.tree("./mean_trees/group_1_mean.txt")
tree2 <- read.tree("./mean_trees/group_2_mean.txt")
par(mfrow = c(1,2))
plot.phylo(tree1, type = "cladogram")
plot.phylo(tree2, type = "cladogram")


## ANOVA
tree_files = list.files("./samples_tree/", pattern = "\\.txt$")
n = c()
for (file in tree_files){
  num_lines <- length(readLines(file.path("samples_tree", file)))
  n = c(n, num_lines)
}

k = length(n)
N = sum(n)

dis_1 = as.numeric(read.table("./distances/group_1_dis.txt"))
dis_2 = as.numeric(read.table("./distances/group_2_dis.txt"))
dis = c(dis_1, dis_2)

dis_sep1 = read.table("./distances/group_1_dis_sep.txt")
dis_sep2 = read.table("./distances/group_2_dis_sep.txt")
