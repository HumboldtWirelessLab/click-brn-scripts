#!/usr/bin/Rscript

library(igraph)

# Settings
links_file_path = "links.csv"
links_of_largest_component_file_path = "links_of_largest_component.csv"
edges_of_largest_component_file_path = "nodes_of_largest_component.csv"
metric_threshold = 100

# Read in graph
print(paste("Read files... ", links_file_path))
links_unfiltered = read.csv(file = links_file_path)
links = as.matrix(links_unfiltered[ links_unfiltered$metric <= metric_threshold,])
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

cl = clusters(g)
largest_component = induced.subgraph(g, which(cl$membership == which.max(cl$csize)))
g = largest_component

# Write
edges = get.edgelist(g)
print(paste("Write... ", links_of_largest_component_file_path))
write.table(edges, file=links_of_largest_component_file_path, sep=",", col.names=c("node_a", "node_b"), row.names = FALSE)

vertexes = V(g)$name
print(paste("Write... ", edges_of_largest_component_file_path))
write.table(vertexes, file=edges_of_largest_component_file_path, sep=",", row.names = FALSE, col.names=FALSE)
