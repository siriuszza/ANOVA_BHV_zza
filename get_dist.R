
distances_dir = "distances"

if (!dir.exists(distances_dir)) {
  dir.create(distances_dir)
}

setwd(mean_trees_dir)

gtp_jar = "../gtp.jar" 

mean_files = list.files(pattern = "_mean\\.txt$")

for (file in mean_files) {
  temp_merge_file = "temp_merge.txt"
  output_file = file.path("..", distances_dir, 
                          sub("_mean\\.txt$", "_dis.txt", file))
  
  file_content = c(readLines(file), readLines("mean_all.txt"))
  writeLines(file_content, temp_merge_file)
  
  system(sprintf("java -jar %s -v %s", gtp_jar, temp_merge_file))
  
  output_content = read.table("output.txt")[, 3]
  writeLines(as.character(output_content), output_file)
  
  file.remove(temp_merge_file)
}

file.remove("output.txt")

setwd("../samples_tree")
sample_files = list.files(pattern = "\\.txt$")

for (file in sample_files) {
  output_file_sep = file.path("..", distances_dir, 
                              sub("\\.txt$", "_dis_sep.txt", file))
  file_lines = readLines(file)
  
  for (line in file_lines) {
    temp_merge_file = "temp_merge.txt"
    mean_file = file.path("..", mean_trees_dir, 
                          sub("\\.txt$", "_mean.txt", file))
    
    file_content = c(line, readLines(mean_file))
    writeLines(file_content, temp_merge_file)
    
    system(sprintf("java -jar %s -v %s", 
                   gtp_jar, temp_merge_file))
    
    output_content = read.table("output.txt")[, 3]
    cat(as.character(output_content), 
        file = output_file_sep, sep = "\n", append = TRUE)
    
    file.remove(temp_merge_file)
  }
}

file.remove("output.txt")
setwd("../")
