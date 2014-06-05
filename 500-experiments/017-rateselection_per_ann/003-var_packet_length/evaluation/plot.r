library(ggplot2)

file_name = "measurement.postxslt"
dataset = read.csv(file_name, colClasses=c("character", "character", "integer", "integer"))
id_list = unique(dataset$ID)
for(id in id_list) {
  dataset_of_link = dataset[dataset$ID==id,]
  dataset_of_link$Rate = factor(dataset_of_link$Rate, levels=levels(factor(as.integer(dataset_of_link$Rate))))
  
  plot = ggplot(data=dataset_of_link )
  plot = plot + ggtitle(id)
  plot = plot + theme_bw()
  plot = plot + geom_line(aes(x=Length, y=Replies, group=Rate, color=Rate, fill=Rate, facet=Rate ))
  plot = plot + geom_point(aes(x=Length, y=Replies, group=Rate, color=Rate, fill=Rate, facet=Rate ))
  #plot = plot + geom_bar(stat="bin", aes(x=Length, color=Rate, fill=Rate, facet=Rate ))
  plot = plot + facet_wrap(~ Rate)
  plot 
  ggsave(file = paste('output-' , id , '.svg', sep=""))
}