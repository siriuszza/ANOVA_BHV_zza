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

dis_1 = as.numeric(read.table("./distances/triangle_dis.txt"))
dis_2 = as.numeric(read.table("./distances/weighted_quadrilateral_dis.txt"))
dis = c(dis_1, dis_2)

dis_sep1 = read.table("./distances/triangle_dis_sep.txt")
dis_sep2 = read.table("./distances/weighted_quadrilateral_dis_sep.txt")

numerator = ( sum(n * dis^2) / (k - 1) )
denominator = ( (sum(dis_sep1^2) + sum(dis_sep2^2)) / (N-k) )

Fs = numerator / denominator
Fs > qf(1-0.05, k-1, N-k)

pf(Fs, k-1, N-k, lower.tail = FALSE)

