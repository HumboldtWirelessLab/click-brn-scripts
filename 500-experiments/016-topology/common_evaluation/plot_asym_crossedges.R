#!/usr/bin/Rscript

suppressPackageStartupMessages(library(ggplot2))

df = read.csv(file="asym_crossedges.csv")

breite=30
max_time = 9000
df_first_searches = df[df$time <= max_time,]

p = ggplot(df_first_searches)
p = p + theme_set(theme_bw())
p = p + labs(title= "Asym. Querverbindungen pro Suche", x="Suche", y="Anzahl der asym. Querverbindungen")
p = p + geom_histogram(aes(x=searchId))
p = p + theme_set(theme_bw())
p = p + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
p

ggsave("asym_crossedges_per_searche_cutted.pdf")


p = ggplot(df_first_searches)
p = p + theme_set(theme_bw())
p = p + labs(title= sprintf("Asym. Querverbindungen pro %d Sekunden ", breite), x="Zeit [s]", y="Anzahl der Querverbindungen")
p = p + geom_histogram(aes(x=time), binwidth=30)
p = p + theme_set(theme_bw())
p = p + theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1))
#p = p + scale_x_continuous(breaks=seq(15, max_time, 30))
p

ggsave("asym_crossedges_per_time_cutted.pdf")
