# Library
library(pomp)
library(ggplot2)
library(reshape2)
library(dplyr)
library(lubridate) 
library(scales)
library(gridExtra)
library(cowplot)
library(tidyr)

# Load reported data
reported <- read.delim(file = "ncr-reported-projection-data.csv" , sep = ',', header = TRUE)

# Plot reported data
fit <- ggplot() +
  geom_col(reported, mapping = aes(x=as.Date(date, format="%d-%b-%y") , y=reported, fill = "Reported Data")) +
  scale_x_date(date_breaks = "1 month", 
               labels=date_format("%b-%Y"),
               limits = as.Date(c('2020-03-01','2020-07-31'))) +
  scale_fill_manual("",values=alpha("orange",0.5)) + 
  theme_classic() +
  labs(title=paste0("Reported COVID-19 Cases in NCR Philippines")) +
  labs(x="Date", y="Number of Cases") +
  theme(legend.position = "top") +
  theme(plot.margin = margin(.5,1,.5,.5, "cm"))
fit

# Save plot
ggsave(plot = fit,
       filename = "ncr-reported-cases.png",
       width = 7, height = 5, units = "in", dpi = 300)
