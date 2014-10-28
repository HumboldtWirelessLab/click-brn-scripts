#!/usr/bin/Rscript

suppressPackageStartupMessages(library(igraph))

# Settings
args <- (commandArgs(TRUE))
links_file_path = "links_filtered.csv"
if(length(args) > 0)
{
  links_file_path = args[1]
}

# Read in graph
links = read.csv(file = links_file_path)
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

if(nrow(links) > 0){
	theoretical_articulation_points = as.matrix(V(g)[articulation.points(g)]$name)
} else {
	theoretical_articulation_points = matrix(nrow = 0, ncol = 1)
}
cat("found", nrow(theoretical_articulation_points), "articulation points\n", file=stderr())

# Write theoretical results
write.table(theoretical_articulation_points, file=stdout(), sep=",", col.names=c("articulation_point"), row.names = FALSE)
