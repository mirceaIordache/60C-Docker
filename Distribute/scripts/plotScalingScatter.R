library(dplyr)
library(ggplot2)

theme_set(theme_bw())

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
    stop("Usage plotScalingScatter.R <dataFile> <benchmark>")
}

inputFile     <- args[1]
benchmarkName <- args[2]

data <- read.table(inputFile, header = T)
data <- data %>% filter (benchmark == benchmarkName)

scaling <- data %>% group_by(variant) %>% mutate(speedup = runtime [workers == 1] / runtime)

maxSpeedup = max(scaling$speedup)

# Loosly based on https://rpubs.com/Koundy/71792
theme_publication <- function() {
  theme_bw () +
  theme(
    plot.title = element_text(face = "bold", size = rel(2), hjust = 0.5),
    panel.border = element_rect(colour = NA),
    axis.title = element_text(face = "bold",size = rel(2.5)),
    axis.title.y = element_text(angle=90,vjust =2),
    axis.title.x = element_text(vjust = -0.2),
    axis.text = element_text(size = rel(2)),
    axis.line = element_line(colour="black"),
    axis.ticks = element_line(),
    legend.key = element_rect(colour = NA),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.key.size = unit(0.45, "cm"),
    legend.margin = unit(0.3, "cm"))
}

plts <- scaling %>% group_by(variant) %>%
  do (
      plot = ggplot(data=., aes(x = workers, y = speedup)) +
             geom_point() +
             ggtitle(paste0("Maximum Clique: ", .$variant, " ", .$benchmark)) +
             xlab("Workers") +
             ylab("Speedup") +
             ylim(c(-1, maxSpeedup + 5)) +
             theme_publication()
    , var = .$variant
    )

mapply(function(plot, var) {
  filename = paste0(benchmarkName, "-", var, "-sampled.eps")
  setEPS()
  postscript(filename, horizontal = F)
  print(plot)
  dev.off()
}, plot = plts$plot, var = plts$var)
