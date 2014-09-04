#!/usr/bin/Rscript

library(ggplot2)


df = read.csv(file="links_distances.csv")

pdf("link_distances_plot.pdf")

p = ggplot(df)
p = p + theme_set(theme_bw())
p = p + labs(title="Anzahl der Linkentfernungen in 5-er Schritten", y="Anzahl", x="Entfernung")
p = p + geom_histogram(aes(x=distance), binwidth=5)
p = p + theme_set(theme_bw())
p

dev.off()

