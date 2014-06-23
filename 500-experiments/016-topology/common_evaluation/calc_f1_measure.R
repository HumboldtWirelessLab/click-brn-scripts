#!/usr/bin/Rscript

library(igraph)

# Settings
runs_file_path = "runs.csv"
theo_ap_path = "theoretical_articulation_points.csv"
theo_br_file_path = "theoretical_bridges.csv"
pr_br_file_path = "bridges.csv"
pr_ap_path = "articulation_points.csv"
result_file_path = "result.csv"
links_file_path = "links.csv"

# Read in results
print(paste("Read ", pr_br_file_path))
pr_br = as.matrix(read.csv(file = pr_br_file_path))
print(paste("Read ", theo_br_file_path))
theo_br = as.matrix(read.csv(file = theo_br_file_path))
print(paste("Read ", pr_ap_path))
pr_ap = as.matrix(read.csv(file = pr_ap_path))
print(paste("Read ", theo_ap_path))
theo_ap = as.matrix(read.csv(file = theo_ap_path))
print(paste("Read ", runs_file_path))
num_of_runs = as.integer(read.csv(file = runs_file_path))
print(paste("Read files... ", links_file_path))
links = as.matrix(read.csv(file = links_file_path))
g = graph.data.frame(links, directed = FALSE)

# Process articulation points
ap_tp = sum(pr_ap %in% theo_ap)
ap_fp = length(pr_ap) - ap_tp
ap_tp_fn = num_of_runs * length(theo_ap);
ap_fn = ap_tp_fn - ap_tp
ap_fp_tn = (length(V(g)) - length(theo_ap)) * num_of_runs
ap_tn = ap_fp_tn - ap_fp

result = list()
result = rbind(result, c("ap_tp", ap_tp))
result = rbind(result, c("ap_fp", ap_fp))
result = rbind(result, c("ap_tn", ap_tn))
result = rbind(result, c("ap_fn", ap_fn))

# Process bridges (tp=true positive, fn=false negative and so on)
theo_br_fwd = interaction(theo_br[,1],theo_br[,2])
theo_br_rev = interaction(theo_br[,2],theo_br[,1])
pr_br = interaction(pr_br[,1], pr_br[,2])

br_tp = sum(pr_br %in% theo_br_fwd) + sum(pr_br %in% theo_br_rev)
br_fp = length(pr_br) - br_tp
br_tp_fn = num_of_runs * length(theo_br_fwd);
br_fn = br_tp_fn - br_tp
br_fp_tn = (length(E(g)) - length(theo_br_fwd)) * num_of_runs
br_tn = br_fp_tn - br_fp

result = rbind(result, c("br_tp", br_tp))
result = rbind(result, c("br_fp", br_fp))
result = rbind(result, c("br_tn", br_tn))
result = rbind(result, c("br_fn", br_fn))
result = rbind(result, c("num_edges", length(E(g))))
result = rbind(result, c("num_vertexes", length(V(g))))

# Write result
print(paste("Write... ", result_file_path))
write.table(result, file=result_file_path, sep=",", col.names=c("key", "value"), row.names = FALSE)
