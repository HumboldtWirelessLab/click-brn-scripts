#!/usr/bin/Rscript

library(igraph)

get.bridges <- function(g)
{
  origin_component_num = clusters(g)$no
  bridges = list()
  
  edges = get.edgelist(g)
  for(i in 1:nrow(edges)) 
  {
    edge_pair_num = edges[i,]
    edge = E(g, P=c(edge_pair_num))
    cutted_graph = delete.edges(g, edge)
    if(clusters(cutted_graph)$no > origin_component_num)
    {
      bridges[[i]] = c(edge_pair_num)
    }
  }
  
  do.call(rbind, bridges)  
}

# Settings
links_file_path = "links.csv"

# Read in graph
print(paste("Read files... ", links_file_path))
links = as.matrix(read.csv(file = links_file_path))
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

theoretical_bridges = get.bridges(g)

# Write theoretical results
theoretical_bridges_file_path = "theoretical_bridges.csv"
print(paste("Write files... ", theoretical_bridges_file_path))
write.table(theoretical_bridges, file=theoretical_bridges_file_path, sep=",", col.names=c("node_a", "node_b"), row.names = FALSE)
