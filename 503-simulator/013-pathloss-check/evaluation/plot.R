#!/usr/bin/Rscript

library("methods")
library(ggplot2)


df = read.csv(file="rx_result.dat", sep=' ')
df$rx_probability = df$received_packages / df$real_sent

pdf("rx_probability.pdf")

p = ggplot(df, aes(x=distance, y=rx_probability))
p = p + labs(title="RX Wahrscheinlichkeit für 100 Byte Pakete", y="RX Wahrscheinlichkeit", x="Entfernung zum Sender")
p = p + theme_set(theme_bw())
p = p + geom_point(alpha=0.3, size=1.2, shape=21)
p = p + stat_summary(fun.y=median, fun.ymin = median, fun.ymax = median, geom = "line")
p = p + theme_set(theme_bw())
p

garbage = dev.off()
