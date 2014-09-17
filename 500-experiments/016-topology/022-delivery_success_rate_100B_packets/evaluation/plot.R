#!/usr/bin/Rscript

library("methods")
library(ggplot2)

raw = read.csv(file = "result.csv")
raw$rx_probability = raw$received_packages / raw$real_sent
attach(raw)
distance = as.factor(distance)

packet.size = mean(packet_size)
sample.size = mean(sample_size)
rx.sd = aggregate(rx_probability~distance, data = raw, sd)[,2]
rx.mean = aggregate(rx_probability~distance, data = raw, mean)[,2]
distance.count = as.vector(table(distance))

df = data.frame(distance = as.numeric(levels(distance)), sd = rx.sd, mean = rx.mean, num = distance.count)

p = ggplot(df, aes(x = distance, y = mean))
p = p + labs(title = sprintf("RX Wahrscheinlichkeit für %d Byte Pakete", packet.size), 
             y = "RX Wahrscheinlichkeit", 
             x = "Entfernung zum Sender")
p = p + theme_set(theme_bw())
p = p + geom_point(alpha = 0.3, size = 0.5, shape = 21) 
p = p + geom_errorbar(aes(ymin = rx.mean - rx.sd, ymax = rx.mean + rx.sd), size = 0.3, alpha = 0.3)
p = p + stat_summary(fun.y = mean, fun.ymin = mean, fun.ymax = mean, geom = "line")
p = p + theme_set(theme_bw())
p

ggsave("rx_probability.pdf")
