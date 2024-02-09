# library(distory)
# 
# newick1 <- "((1:1,(2:1,3:1):4):4,4:1);"
# newick2 <- "(((4:1,3:1):4,2:1):4,1:1);"
# 
# tree1 <- read.tree(text = newick1)
# tree2 <- read.tree(text = newick2)
# trees <- list(tree1, tree2)
# 
# distances <- dist.multiPhylo(trees, method = "geodesic")
# 
# print(distances)

library(distory)

tree1 <- read.tree("./mean_trees/triangle_mean.txt")
tree2 <- read.tree("./mean_trees/weighted_quadrilateral_mean.txt")
plot(tree1)
plot(tree2)

## ANOVA
n = c(3, 9)

k = length(n)
N = sum(n)

dis = c(1.90852, 0.816329)

dis1 = read.table("./mean_trees/triangle_dis_sep.txt")
dis2 = read.table("./mean_trees/weighted_quadrilateral_dis_sep.txt")

fz = ( sum(n * dis^2) / (k - 1) )
fm = ( (sum(dis1^2) + sum(dis2^2)) / (N-k) )
Fs = fz / fm
Fs > qf(1-0.05, k-1, N-k)

pf(Fs, k-1, N-k, lower.tail = FALSE)

