library(ape)
n = 100
len1 = abs(rnorm(n, 0, 10)) + 0.1
len2 = abs(rnorm(n, 1, 10)) + 0.1
len3 = abs(rnorm(n, 2, 10)) + 0.1
len4 = abs(rnorm(n, 3, 10)) + 0.1
len5 = abs(rnorm(n, 4, 10)) + 0.1
len6 = abs(rnorm(n, 5, 10)) + 0.1


newick_trees_1 = 
  paste0(
    "((t1:",
    len1,
    ",t2:",
    len2,
    "):",
    len3,
    ",(t3:",
    len4,
    ",t4:",
    len5,
    "):",
    len6,
    ");"
  )


newick_trees_2 = 
  paste0(
    "(t3:",
    len1+1,
    ",(t2:",
    len2+1,
    ",(t1:",
    len3+1,
    ",t4:",
    len4+1,
    "):",
    len5+1,
    "):",
    len6+1,
    ");"
  )

write.table(newick_trees_1, "./samples_tree/group_1.txt",
            col.names = F, row.names = F,
            quote = F)
write.table(newick_trees_2, "./samples_tree/group_2.txt",
            col.names = F, row.names = F,
            quote = F)
# trees_1 = read.tree(text = newick_trees_1)
# plot.phylo(trees_1[[1]])
# 
# 
# trees_2 = read.tree(text = newick_trees_2)
# plot.phylo(trees_2[[1]])

# library(TreeSim)
# n <- 4 # Number of taxa
# numbsim <- 1 # Number of trees to simulate
# lambda <- 2 # Speciation rate
# mu <- 0.1 # Extinction rate
# 
# # Simulate the tree
# # tree = sim.bd.taxa(n, numbsim, lambda, mu, frac = 1, complete = TRUE, stochsampling = FALSE)
# tree = sim.bd.taxa(n, numbsim, lambda, mu)
# plot.phylo(tree[[1]])
# newick_tree <- write.tree(tree[[1]])
# newick_tree

# install.packages("./apTreeshape_1.5-0.1.tar", repos = NULL, type = "source")

library(apTreeshape)

aa = simulate_tree(epsilon=0.1, alpha = 1, beta = -1, N = 100)


plot.phylo(aa)





