library(phylodyn)
library(ape)
library(apTreeshape)

setwd("F:\\office\\research\\solislemus\\BHV\\ANOVA_BHV_zza")

if (!dir.exists("samples_tree")) {
  dir.create("samples_tree")
}

# Function to read parameters from a text file
read_parameters <- function(file) {
  params <- read.table(file, header = TRUE, stringsAsFactors = FALSE)
  params <- na.omit(params)
  return(params)
}

# Function to generate and save trees with specified parameters
generate_and_save_trees <- function(num_trees, alpha, beta, epsilon, N, group_num) {
  # Create a file name based on the parameters
  file_name <- sprintf("samples_tree/group_%d.txt", group_num)
  
  trees <- list()
  
  for (i in 1:num_trees) {
    # Generate a tree with specified parameters
    tree <- apTreeshape::simulate_tree(epsilon = epsilon, alpha = alpha, beta = beta, N = N)
    trees[[i]] <- add_lable(tree)
  }
  
  # Write all trees to a single text file
  write.tree(trees, file = file_name)
  return(trees)
}

# Function to get the terminal nodes of a given tree
find_terminal <- function(tree) {
  return(tree$edge[,2][!tree$edge[,2] %in% tree$edge[,1]])
}

# Function to add labels based on the rule of ranked tree paper
add_lable <- function(tree) {
  terminal <- find_terminal(tree)
  labels <- cbind(terminal, rep(NA, length(terminal)))
  edge1 <- tree$edge[,1]
  edge2 <- tree$edge[,2]
  node_i <- 1
  for (node in unique(edge1)[order(unique(edge1), decreasing = TRUE)]) {
    children <- edge2[edge1 == node]
    for (child in children[order(children)]) {
      if (child %in% terminal) {
        labels[,2][labels[,1] == child] <- paste('t', node_i, sep = '')
        node_i <- node_i + 1
      }
    }
  }
  tree$tip.label <- labels[,2]
  return(tree)
}

# Read parameters from the parameter.txt file
params <- read_parameters("parameter.txt")

# Initialize a list to store all trees
all_trees <- list()

# Iterate over each row in the parameters table
for (i in 1:nrow(params)) {
  num_trees <- as.numeric(params$num_trees[i])
  alpha <- as.numeric(params$alpha[i])
  beta <- as.numeric(params$beta[i])
  epsilon <- as.numeric(params$epsilon[i])
  N <- as.numeric(params$N[i])
  
  # Generate and save trees for the current group
  group_trees <- generate_and_save_trees(num_trees, alpha, beta, epsilon, N, i)
  
  # Add the group's trees to the all_trees list
  all_trees <- c(all_trees, group_trees)
}

# Save all trees in a single file
dir.create("samples_tree", showWarnings = FALSE)
write.tree(all_trees, file = "samples_tree/all_tree")
