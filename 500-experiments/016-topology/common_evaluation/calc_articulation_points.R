#!/usr/bin/Rscript

library(igraph)

# Settings
links_file_path = "links.csv"

# Read in graph
print(paste("Read files...", links_file_path))
links = as.matrix(read.csv(file = links_file_path))
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

theoretical_articulation_points = as.matrix(V(g)[articulation.points(g)]$name)

# Write theoretical results
theoretical_articulation_points_file_path = "theoretical_articulation_points.csv"
print(paste("Write files...", theoretical_articulation_points_file_path))
write.table(theoretical_articulation_points, file=theoretical_articulation_points_file_path, sep=",", col.names=c("articulation_point"), row.names = FALSE)
