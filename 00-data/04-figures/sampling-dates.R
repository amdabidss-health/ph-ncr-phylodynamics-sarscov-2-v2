
##Load libraries
require(pacman)
p_load(EpiCurve,dplyr,tidyr,pacman, ggplot2,ggthemes,broom,stringr,ggpubr,scales,lubridate)

#Read data
metadata <- read.delim(file = "ncrCleanAlignTrimmed.tsv", sep = '\t', header = TRUE)
metadata$date <- as.Date(metadata$date, format="%Y-%m-%d")

#Make column for VOC
metadata$voc = metadata$pangolin_lineage
metadata['voc'] = "Non VOC"
for(i in 1:nrow(variants)){
  metadata$voc <- ifelse(grepl(as.character(paste0("^",variants[i,1],"$")), metadata$pangolin_lineage),as.character(variants[i,2]), metadata$voc)
}

#Plot date
date <- metadata %>% left_join(metadata %>% group_by(division) %>% summarise(N=n()))%>%
  mutate(Label=paste0(division,' (n = ',N,')')) %>%
  ggplot(metadata, mapping = aes(date)) + 
  geom_histogram(binwidth = 1) +
  scale_x_date(labels = date_format("%b-%Y"), 
               date_breaks = '1 month') +
  ylab("Frequency") + xlab("Month and Year") + 
  theme_bw() +
  labs(title=paste0("Distribution of Collection Date")) +
  facet_wrap(~Label, ncol=1) + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) +
  theme(plot.margin = margin(.5,1,.5,.5, "cm"))
date

#Save plot
ggsave (plot = date,
        filename = "ncr.collection.date.png",
        width = 7, height = 5, units = "in", dpi = 300)