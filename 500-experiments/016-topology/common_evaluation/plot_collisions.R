#!/usr/bin/Rscript

library(ggplot2)

df = read.csv(file="collisions.csv")

pdf("collisions_per_node.pdf")

p = ggplot(df)
p = p + theme_set(theme_bw())
p = p + labs(title= "Kollisionen pro Knoten", x="Knoten", y="Anzahl der Kollisionen")
p = p + geom_histogram(aes(x=node))
p = p + theme_set(theme_bw())
p = p + theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1))
p

dev.off()


pdf("collisions_per_time.pdf")

breite=30
max_time = 9000
df_first_searches = df[df$time <= max_time,]
p = ggplot(df_first_searches)
p = p + labs(title= sprintf("Kollisionen pro %d Sekunden", breite), x="Zeit [s]", y="Anzahl der Kollisionen")
p = p + geom_histogram(aes(x=time), binwidth=30)
p = p + theme_set(theme_bw())
p = p + theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1))
#p = p + scale_x_continuous(breaks=seq(15, max_time, 30))
p

dev.off()
