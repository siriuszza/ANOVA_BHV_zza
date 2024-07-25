library(phylodyn)
library(ape)
library(apTreeshape)

ranked_tree <- apTreeshape::simulate_tree(epsilon = 1,alpha = 0.5,beta = 0.5,N = 10)
plot(ranked_tree,  show.node.label = TRUE ,  show.tip.label = TRUE)
nodelabels()
tiplabels()
# get the terminal nodes of a given tree
find_terminal <-  function(tree){
  return(tree$edge[,2][!tree$edge[,2]%in%tree$edge[,1]])
}

# add labels based on the the rule of ranked tree paper
add_lable <- function(tree){
  terminal <- find_terminal(tree)
  lables <- cbind(terminal,rep(NA,length(terminal)))
  edge1 <- tree$edge[,1]
  edge2 <- tree$edge[,2]
  node_i <- 1
  for (node in unique(edge1)[order(unique(edge1),decreasing = T)]){
    children <- edge2[edge1 == node]
    #print(children)
    for (child in children[order(children)]) {
      if (child %in% terminal){
        lables[,2][lables[,1]==child] = paste('t',node_i,sep = '')
        node_i = node_i + 1
      }
    }
  }
  tree$tip.label = lables[,2]
  return(tree)
}



ranked_tree_labled <- add_lable(ranked_tree)

plot(ranked_tree_labled,  show.node.label = TRUE ,  show.tip.label = TRUE)
nodelabels()
#tiplabels()
write.tree(ranked_tree_labled,"ranked_tree_labled.txt")




# tree <- rcoal(4)
# 
# # Plot the tree
# plot(tree, show.node.label = TRUE,  show.tip.label = TRUE)
# #nodelabels()
# #tiplabels()
# write.tree(tree,"unranked_tree.txt")

# Load necessary libraries
# Load necessary libraries
library(apTreeshape)
library(ape)

# Function to generate and save trees with specified parameters
generate_and_save_trees <- function(num_trees, alpha, beta, epsilon, N) {
  # Create a file name based on the parameters
  file_name <- sprintf("ranked_trees_alpha_%s_beta_%s_epsilon_%s_N_%s.txt", alpha, beta, epsilon, N)
  
  trees <- list()
  
  for (i in 1:num_trees) {
    # Generate a tree with specified parameters
    tree <- apTreeshape::simulate_tree(epsilon = epsilon, alpha = alpha, beta = beta, N = N)
    trees[[i]] <- add_lable(tree)
  }
  
  # Write all trees to a single text file
  write.tree(trees, file = file_name)
}

# Specify parameters
num_trees <- 100
alpha <- 1
beta <- -1.9
epsilon <- 1
N <- 10

# Generate and save trees with specified parameters
generate_and_save_trees(num_trees, alpha, beta, epsilon, N)


num_trees <- 100
alpha <- 1
beta <- -1.5
epsilon <- 1
N <- 10

# Generate and save trees with specified parameters
generate_and_save_trees(num_trees, alpha, beta, epsilon, N)


group1 <- read.tree("samples_tree/group_1.txt")
group2 <- read.tree("samples_tree/group_2.txt")
group3 <- read.tree("samples_tree/group_3.txt")
# group4 <- read.tree("samples_tree/group_4.txt")
# group5 <- read.tree("samples_tree/group_5.txt")


all_tree <- c(group1,group2,group3)
write.tree(all_tree,"all_tree")









par(mfrow = c(1, 2))
mean_gp1 <- read.tree("mean_trees/group_1_mean.txt")
plot.phylo(mean_gp1)
mean_gp2 <- read.tree("mean_trees/group_2_mean.txt")
plot.phylo(mean_gp2)





