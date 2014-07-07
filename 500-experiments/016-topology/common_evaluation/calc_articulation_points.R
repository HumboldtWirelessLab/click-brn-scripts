#!/usr/bin/Rscript

library(igraph)

# Settings
args <- (commandArgs(TRUE))
links_file_path = "links.csv"
if(length(args) > 0)
{
  links_file_path = args[1]
}
cat("use input file", links_file_path, "\n", file=stderr())

if(length(args) > 1)
{
    metric_threshold = args[2]
    cat("use ETX metric limit", metric_threshold, "\n", file=stderr())
}else
{
    metric_threshold = 100
    cat("use default ETX metric limit", metric_threshold, "\n", file=stderr())
}

# Read in graph
cat("read file", links_file_path, "\n", file=stderr())
links_unfiltered = read.csv(file = links_file_path)
links = as.matrix(links_unfiltered[ links_unfiltered$metric <= metric_threshold,])
cat( "read (", nrow(links), "/", nrow(links_unfiltered), ") links\n", file=stderr())
g = graph.data.frame(links, directed = FALSE)
# removeduplicated edges
g = as.undirected(as.directed(g))

theoretical_articulation_points = as.matrix(V(g)[articulation.points(g)]$name)
cat("found", nrow(theoretical_articulation_points), "articulation points\n", file=stderr())

# Write theoretical results
write.table(theoretical_articulation_points, file=stdout(), sep=",", col.names=c("articulation_point"), row.names = FALSE)
