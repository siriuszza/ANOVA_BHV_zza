library(ape)
tree1 <- read.tree("./mean_trees/triangle_mean.txt")
tree2 <- read.tree("./mean_trees/weighted_quadrilateral_mean.txt")
par(mfrow = c(1,2))
plot.phylo(tree1, type = "cladogram")
plot.phylo(tree2, type = "cladogram")

## ANOVA
# tree_files = list.files("./samples_tree/", pattern = "\\.txt$")
n = c()
for (file in tree_files){
  num_lines <- length(readLines(file.path("samples_tree", file)))
  n = c(n, num_lines)
}

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

library(TreeSim)
