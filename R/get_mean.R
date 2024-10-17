
work_dir = "../samples_tree"

sturm_mean_jar = "../SturmMean.jar"

mean_trees_dir = "../mean_trees"



if (!dir.exists(mean_trees_dir)) {
  dir.create(mean_trees_dir)
}

setwd(work_dir)

all_tree_file = "all_tree"
cat("", file = all_tree_file)

tree_files = list.files(pattern = "\\.txt$")

for (tree in tree_files) {
  java_cmd = sprintf("java -jar %s -n 1000 -e 0.001 %s",
                     sturm_mean_jar, tree)
  print("1")
  mean_tree = system(java_cmd, intern = TRUE)
  print("2")
  mean_tree_last_line = tail(mean_tree, n = 1)
  print("3")
  mean_tree_file = file.path(mean_trees_dir,
                             paste0(sub("\\.txt$", "", tree),
                                    "_mean.txt"))
  print("4")
  cat("", file = mean_tree_file)
  writeLines(mean_tree_last_line, mean_tree_file)
  print("5")
  file.append(all_tree_file, tree)
}

java_cmd_all = sprintf("java -jar %s -e 0.001 -n 1000 %s",
                       sturm_mean_jar, all_tree_file)
mean_all = system(java_cmd_all, intern = TRUE)
mean_all_last_line = tail(mean_all, n = 1)
mean_all_filtered = grep("[(].*[)];", 
                         mean_all_last_line, 
                         value = TRUE)

mean_all_file = file.path(mean_trees_dir, "mean_all.txt")
writeLines(mean_all_filtered, mean_all_file)

if (file.exists("output.txt")) {
  file.remove("output.txt")
}

setwd("../")