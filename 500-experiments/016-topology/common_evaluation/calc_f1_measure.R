#!/usr/bin/Rscript

library(methods)
library(igraph)


#
# Settings
#
runs_file_path         = "runs.csv"
theo_ap_path           = "theoretical_articulation_points.csv"
theo_br_file_path      = "theoretical_bridges.csv"
pr_all_br_file_path    = "bridges_all.csv"
pr_unique_br_file_path = "bridges_unique_per_search.csv"
pr_ap_path             = "articulation_points.csv"
result_file_path       = "result.csv"
links_file_path        = "links.csv"


#
# Read in results
#
pr_all_br = as.matrix(read.csv(file = pr_all_br_file_path))
pr_unique_br = as.matrix(read.csv(file = pr_unique_br_file_path))
pr_ap = as.matrix(read.csv(file = pr_ap_path))
theo_br = as.matrix(read.csv(file = theo_br_file_path))
theo_ap = as.matrix(read.csv(file = theo_ap_path))
num_of_runs = as.integer(read.csv(file = runs_file_path))
links = as.matrix(read.csv(file = links_file_path))
g = graph.data.frame(links, directed = FALSE)


#
# Process articulation points
#
ap_tp = sum(pr_ap %in% theo_ap)
ap_fp = nrow(pr_ap) - ap_tp
ap_tp_fn = num_of_runs * nrow(theo_ap);
ap_fn = ap_tp_fn - ap_tp
ap_fp_tn = (length(V(g)) - nrow(theo_ap)) * num_of_runs
ap_tn = ap_fp_tn - ap_fp

result = list()
result = rbind(result, c("ap_tp", ap_tp))
result = rbind(result, c("ap_fp", ap_fp))
result = rbind(result, c("ap_tn", ap_tn))
result = rbind(result, c("ap_fn", ap_fn))


#
# Process unique bridges (tp=true positive, fn=false negative and so on)
#
theo_br_fwd = interaction(theo_br[,1],theo_br[,2])
theo_br_rev = interaction(theo_br[,2],theo_br[,1])
pr_unique_br = interaction(pr_unique_br[,1], pr_unique_br[,2])

br_unique_tp    = sum(pr_unique_br %in% theo_br_fwd) + sum(pr_unique_br %in% theo_br_rev)
br_unique_fp    = length(pr_unique_br) - br_unique_tp
br_unique_tp_fn = num_of_runs * nrow(theo_br);
br_unique_fn    = br_unique_tp_fn - br_unique_tp
br_unique_fp_tn = num_of_runs * (length(E(g)) - nrow(theo_br))
br_unique_tn    = br_unique_fp_tn - br_unique_fp

result = rbind(result, c("br_unique_tp", br_unique_tp))
result = rbind(result, c("br_unique_fp", br_unique_fp))
result = rbind(result, c("br_unique_tn", br_unique_tn))
result = rbind(result, c("br_unique_fn", br_unique_fn))


#
# Process all bridges (tp=true positive, fn=false negative and so on)
#
theo_br_fwd   = interaction(theo_br[,1],theo_br[,2])
theo_br_rev   = interaction(theo_br[,2],theo_br[,1])
pr_all_br     = interaction(pr_all_br[,1], pr_all_br[,2])
theo_br_count = nrow(theo_br)

br_all_tp    = sum(pr_all_br %in% theo_br_fwd) + sum(pr_all_br %in% theo_br_rev)
br_all_fp    = length(pr_all_br) - br_all_tp
br_all_tp_fn = num_of_runs * 2 * theo_br_count;  # both nodes will detect one bridge
br_all_fn    = br_all_tp_fn - br_all_tp
br_all_fp_tn = num_of_runs * (2 * length(E(g)) - 2 * theo_br_count)
br_all_tn    = br_all_fp_tn - br_all_fp

result = rbind(result, c("br_all_tp", br_all_tp))
result = rbind(result, c("br_all_fp", br_all_fp))
result = rbind(result, c("br_all_tn", br_all_tn))
result = rbind(result, c("br_all_fn", br_all_fn))


result = rbind(result, c("num_edges", length(E(g))))
result = rbind(result, c("num_vertexes", length(V(g))))
result = rbind(result, c("num_theo_br", nrow(theo_br) * num_of_runs))
result = rbind(result, c("num_theo_ap", nrow(theo_ap) * num_of_runs))
result = rbind(result, c("num_all_pr_br", length(pr_all_br)))
result = rbind(result, c("num_unique_pr_br", length(pr_unique_br)))
result = rbind(result, c("num_pr_ap", length(pr_ap)))
result = rbind(result, c("num_runs", num_of_runs))


#
# Write result
#
write.table(result, file=result_file_path, sep=",", col.names=c("key", "value"), row.names = FALSE)
