#!/usr/bin/Rscript

library(ggplot2)


df = read.csv(file="result.csv")
df$rx_probability = df$received_packages / df$real_sent

p = ggplot(df)
p = p + theme_set(theme_bw())
p = p + geom_point(aes(x=distance, y=rx_probability))
p = p + ylab("RX Propability")
p = p + xlab("Distance")
p
