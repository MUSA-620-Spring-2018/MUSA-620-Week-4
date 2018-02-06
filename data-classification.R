
library(tidyverse)
library(classInt)
library(viridis)
#https://cran.r-project.org/web/packages/classInt/classInt.pdf



nyctaxi <- read.csv("d:/nyc-taxi-classifier.csv", stringsAsFactors = FALSE)



quantile <- classIntervals(nyctaxi$hour12, n=12, style="quantile")
equalInterval <- classIntervals(nyctaxi$hour12, n=12, style="equal")
natural <- classIntervals(nyctaxi$hour12, n=12, style="jenks")





quantileBreaks <- nyctaxi
quantileBreaks <- mutate(quantileBreaks,group="quantile")
quantileBreaks$breaks <- factor(
  cut(as.numeric(quantileBreaks$hour12), c(-1,quantile$brks))
)

equalIntervalBreaks <- nyctaxi
equalIntervalBreaks <- mutate(equalIntervalBreaks,group="equalInterval")
equalIntervalBreaks$breaks <- factor(
  cut(as.numeric(equalIntervalBreaks$hour12), c(-1,equalInterval$brks))
)

naturalBreaks <- nyctaxi
naturalBreaks <- mutate(naturalBreaks,group="natural")
naturalBreaks$breaks <- factor(
  cut(as.numeric(naturalBreaks$hour12), natural$brks)
)


myTheme <- function() {
  theme_void() + 
    theme(
      legend.position="none",
      axis.line = element_line(size = 0.1, colour = "black"),
      axis.text = element_text(colour = "black",size = 8),
      plot.margin = margin(1, 1, 1, 1, 'cm')
    ) 
}

ggplot() +
  geom_bar(data=quantileBreaks,aes(fill=breaks,x=OBJECTID,y=hour12),size = 0,stat="identity") +
  scale_fill_viridis(discrete = TRUE, direction = -1) +
  #scale_x_continuous(limits = c(700,1050)) +
  myTheme()

ggplot() +
  geom_bar(data=equalIntervalBreaks,aes(fill=breaks,x=OBJECTID,y=hour12),size = 0,stat="identity") +
  scale_fill_viridis(discrete = TRUE, direction = -1) +
  #scale_x_continuous(limits = c(700,1050)) +
  myTheme()

ggplot() +
  geom_bar(data=naturalBreaks,aes(fill=breaks,x=OBJECTID,y=hour12),size = 0,stat="identity") +
  scale_fill_viridis(discrete = TRUE, direction = -1) +
  #scale_x_continuous(limits = c(700,1050)) +
  myTheme()

taxisTotal <- rbind(quantileBreaks, equalIntervalBreaks, naturalBreaks)




ggplot() +
  #facet_grid(~group) +
  facet_grid(group ~ .) +
  geom_bar(data=taxisTotal,aes(fill=breaks,x=OBJECTID,y=hour12),stat="identity") +
  scale_fill_viridis(discrete = TRUE, direction = -1) +
  myTheme()
  
  





