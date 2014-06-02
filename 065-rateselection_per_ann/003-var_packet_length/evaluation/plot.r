library(ggplot2)

file_name = "measurement.postxslt"
dataset = read.csv(file_name, colClasses=c("character", "character", "integer", "integer"))
id_list = unique(dataset$ID)
for(id in id_list) {
  dataset_of_link = dataset[dataset$ID==id,]  
  
  plot = ggplot(data=dataset_of_link, aes(x=Length, y=Replies, group=Rate, color=Rate, fill=Rate))
  plot = plot + ggtitle(id)
  plot = plot + theme_bw()
  plot = plot + geom_line()
  plot = plot + geom_point()
  plot 
  ggsave(file = paste('output-' , id , '.svg', sep=""))
}
