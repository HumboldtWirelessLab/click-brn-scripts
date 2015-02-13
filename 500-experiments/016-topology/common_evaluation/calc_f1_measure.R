#!/usr/bin/Rscript

suppressPackageStartupMessages(library(igraph))


#
# Settings
#
runs_file_path         = "runs.csv"
runs_measure_file_path = "runs_measure.csv"
theo_ap_path           = "theoretical_articulation_points.csv"
theo_br_file_path      = "theoretical_bridges.csv"
pr_all_br_file_path    = "bridges_all.csv"
pr_unique_br_file_path = "bridges_unique_per_search.csv"
pr_ap_path             = "articulation_points.csv"
result_file_path       = "result.csv"
links_file_path        = "links_filtered.csv"
etx_threshold_path 	   = "etx_threshold.csv"


#
# Read in results
#
pr_all_br = as.matrix(read.csv(file = pr_all_br_file_path))
pr_unique_br = as.matrix(read.csv(file = pr_unique_br_file_path))
pr_ap = as.matrix(read.csv(file = pr_ap_path))
theo_br = as.matrix(read.csv(file = theo_br_file_path))
theo_ap = as.matrix(read.csv(file = theo_ap_path))
num_of_runs = as.integer(read.csv(file = runs_file_path))
num_of_measure = as.integer(read.csv(file = runs_measure_file_path))
etx_threshold = as.integer(read.csv(file = etx_threshold_path))
links = as.matrix(read.csv(file = links_file_path))
g = graph.data.frame(links, directed = FALSE)


#
# Process articulation points
#
ap_tp = sum(pr_ap %in% theo_ap)
ap_fp = nrow(pr_ap) - ap_tp
ap_tp_fn = num_of_measure * nrow(theo_ap);
ap_fn = ap_tp_fn - ap_tp
ap_fp_tn = (length(V(g)) - nrow(theo_ap)) * num_of_measure
ap_tn = ap_fp_tn - ap_fp

ap_precision = ap_tp / (ap_tp + ap_fp)
ap_recall = ap_tp / (ap_tp + ap_fn)
ap_fallout = ap_fp / (ap_fp + ap_tn)
ap_falsenegative = ap_fn / (ap_fn + ap_tp)
ap_accuracy = (ap_tn + ap_tp) / (ap_fn + ap_tn + ap_fp + ap_tp)
ap_f_measure = (2 * ap_precision * ap_recall) / (ap_precision + ap_recall)

result = list()
result = rbind(result, c("ap_tp", ap_tp))
result = rbind(result, c("ap_fp", ap_fp))
result = rbind(result, c("ap_tn", ap_tn))
result = rbind(result, c("ap_fn", ap_fn))
result = rbind(result, c("ap_precision", ap_precision))
result = rbind(result, c("ap_recall", ap_recall))
result = rbind(result, c("ap_fallout", ap_fallout))
result = rbind(result, c("ap_falsenegative", ap_falsenegative))
result = rbind(result, c("ap_accuracy", ap_accuracy))
result = rbind(result, c("ap_f_measure", ap_f_measure))


#
# Process unique bridges (tp=true positive, fn=false negative and so on)
#
theo_br_fwd = interaction(theo_br[,1],theo_br[,2])
theo_br_rev = interaction(theo_br[,2],theo_br[,1])
pr_br = interaction(pr_unique_br[,1], pr_unique_br[,2])

br_unique_tp    = sum(pr_br %in% theo_br_fwd) + sum(pr_br %in% theo_br_rev)
br_unique_fp    = length(pr_br) - br_unique_tp
br_unique_tp_fn = num_of_measure * nrow(theo_br);
br_unique_fn    = br_unique_tp_fn - br_unique_tp
br_unique_fp_tn = num_of_measure * (length(E(g)) - nrow(theo_br))
br_unique_tn    = br_unique_fp_tn - br_unique_fp

br_unique_precision = br_unique_tp / (br_unique_tp + br_unique_fp)
br_unique_recall = br_unique_tp / (br_unique_tp + br_unique_fn)
br_unique_fallout = br_unique_fp / (br_unique_fp + br_unique_tn)
br_unique_falsenegative = br_unique_fn / (br_unique_fn + br_unique_tp)
br_unique_accuracy = (br_unique_tn + br_unique_tp) / (br_unique_fn + br_unique_tn + br_unique_fp + br_unique_tp)
br_unique_f_measure = (2 * br_unique_precision * br_unique_recall) / (br_unique_precision + br_unique_recall)

result = rbind(result, c("br_unique_tp", br_unique_tp))
result = rbind(result, c("br_unique_fp", br_unique_fp))
result = rbind(result, c("br_unique_tn", br_unique_tn))
result = rbind(result, c("br_unique_fn", br_unique_fn))
result = rbind(result, c("br_unique_precision", br_unique_precision))
result = rbind(result, c("br_unique_recall", br_unique_recall))
result = rbind(result, c("br_unique_fallout", br_unique_fallout))
result = rbind(result, c("br_unique_falsenegative", br_unique_falsenegative))
result = rbind(result, c("br_unique_accuracy", br_unique_accuracy))
result = rbind(result, c("br_unique_f_measure", br_unique_f_measure))


#
# Process all bridges (tp=true positive, fn=false negative and so on)
#
theo_br_fwd   = interaction(theo_br[,1],theo_br[,2])
theo_br_rev   = interaction(theo_br[,2],theo_br[,1])
pr_br         = interaction(pr_all_br[,1], pr_all_br[,2])
theo_br_count = nrow(theo_br)

br_all_tp    = sum(pr_br %in% theo_br_fwd) + sum(pr_br %in% theo_br_rev)
br_all_fp    = length(pr_br) - br_all_tp
br_all_tp_fn = num_of_measure * 2 * theo_br_count;  # both nodes will detect one bridge
br_all_fn    = br_all_tp_fn - br_all_tp
br_all_fp_tn = num_of_measure * (2 * length(E(g)) - 2 * theo_br_count)
br_all_tn    = br_all_fp_tn - br_all_fp

br_all_precision = br_all_tp / (br_all_tp + br_all_fp)
br_all_recall = br_all_tp / (br_all_tp + br_all_fn)
br_all_fallout = br_all_fp / (br_all_fp + br_all_tn)
br_all_falsenegative = br_all_fn / (br_all_fn + br_all_tp)
br_all_accuracy = (br_all_tn + br_all_tp) / (br_all_fn + br_all_tn + br_all_fp + br_all_tp)
br_all_f_measure = (2 * br_all_precision * br_all_recall) / (br_all_precision + br_all_recall)

result = rbind(result, c("br_all_tp", br_all_tp))
result = rbind(result, c("br_all_fp", br_all_fp))
result = rbind(result, c("br_all_tn", br_all_tn))
result = rbind(result, c("br_all_fn", br_all_fn))
result = rbind(result, c("br_all_precision", br_all_precision))
result = rbind(result, c("br_all_recall", br_all_recall))
result = rbind(result, c("br_all_fallout", br_all_fallout))
result = rbind(result, c("br_all_falsenegative", br_all_falsenegative))
result = rbind(result, c("br_all_accuracy", br_all_accuracy))
result = rbind(result, c("br_all_f_measure", br_all_f_measure))


#
# Classification tree {unknown, {Bridge, Non-Bridge}}
#
valid_links      = interaction(links[,1], links[,2]) # containing fwd and rev
theo_br_fwd      = interaction(theo_br[,1],theo_br[,2])
theo_br_rev      = interaction(theo_br[,2],theo_br[,1])
pr_br            = interaction(pr_all_br[,1], pr_all_br[,2])
pr_classified_br = pr_br[pr_br %in% valid_links]

br_class_tp    = sum(pr_classified_br %in% theo_br_fwd) + sum(pr_classified_br %in% theo_br_rev)
br_class_fp    = length(pr_classified_br) - br_class_tp
br_class_tp_fn = num_of_measure * 2 * theo_br_count;  # both nodes will detect one bridge
br_class_fn    = br_class_tp_fn - br_class_tp
br_class_fp_tn = num_of_measure * (2 * length(E(g)) - 2 * theo_br_count)
br_class_tn    = br_class_fp_tn - br_class_fp

br_class_precision = br_class_tp / (br_class_tp + br_class_fp)
br_class_recall = br_class_tp / (br_class_tp + br_class_fn)
br_class_fallout = br_class_fp / (br_class_fp + br_class_tn)
br_class_falsenegative = br_class_fn / (br_class_fn + br_class_tp)
br_class_accuracy = (br_class_tn + br_class_tp) / (br_class_fn + br_class_tn + br_class_fp + br_class_tp)
br_class_f_measure = (2 * br_class_precision * br_class_recall) / (br_class_precision + br_class_recall)

result = rbind(result, c("br_class_classified", length(pr_classified_br)))
result = rbind(result, c("br_class_unclassified", length(pr_br) - length(pr_classified_br)))

result = rbind(result, c("br_class_tp", br_class_tp))
result = rbind(result, c("br_class_fp", br_class_fp))
result = rbind(result, c("br_class_tn", br_class_tn))
result = rbind(result, c("br_class_fn", br_class_fn))
result = rbind(result, c("br_class_precision", br_class_precision))
result = rbind(result, c("br_class_recall", br_class_recall))
result = rbind(result, c("br_class_fallout", br_class_fallout))
result = rbind(result, c("br_class_falsenegative", br_class_falsenegative))
result = rbind(result, c("br_class_accuracy", br_class_accuracy))
result = rbind(result, c("br_class_f_measure", br_class_f_measure))

result = rbind(result, c("num_edges", length(E(g))))
result = rbind(result, c("num_vertexes", length(V(g))))
result = rbind(result, c("num_theo_br_per_measure", nrow(theo_br)))
result = rbind(result, c("num_theo_ap_per_measure", nrow(theo_ap)))
result = rbind(result, c("num_theo_br", nrow(theo_br) * num_of_measure))
result = rbind(result, c("num_theo_ap", nrow(theo_ap) * num_of_measure))
result = rbind(result, c("probability_theo_br", round(nrow(theo_br) / length(V(g)), 3) ))
result = rbind(result, c("probability_theo_ap", round(nrow(theo_ap) / length(E(g)), 3) ))
result = rbind(result, c("num_all_pr_br", nrow(pr_all_br)))
result = rbind(result, c("num_unique_pr_br", nrow(pr_unique_br)))
result = rbind(result, c("num_pr_ap", nrow(pr_ap)))
result = rbind(result, c("num_runs", num_of_runs))
result = rbind(result, c("num_measure", num_of_measure))
result = rbind(result, c("etx_threshold", etx_threshold))


#
# Write result
#
write.table(result, file=result_file_path, sep=",", col.names=c("key", "value"), row.names = FALSE)
