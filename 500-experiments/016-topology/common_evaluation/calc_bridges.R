#!/usr/bin/Rscript

library(methods)
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
args <- (commandArgs(TRUE))
links_file_path = "links_fildered.csv"
if(length(args) > 0)
{
  links_file_path = args[1]
}

# Read in graph
links = read.csv(file = links_file_path)
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

theoretical_bridges = get.bridges(g)
cat("found", nrow(theoretical_bridges), "bridges\n", file=stderr())

# Write theoretical results
if(is.null(theoretical_bridges))  
{
    write.table(theoretical_bridges, file=stdout(), sep=",", row.names = FALSE)
}else 
{
    write.table(theoretical_bridges, file=stdout(), sep=",", col.names=c("node_a", "node_b"), row.names = FALSE)
}

