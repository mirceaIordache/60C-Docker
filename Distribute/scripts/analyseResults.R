library(dplyr)
library(ggplot2)
library(grid)
library(cowplot)

# Loosly based on https://rpubs.com/Koundy/71792
theme_publication <- function() {
  theme_bw () +
  theme(
    plot.title = element_text(face = "bold", size = rel(1.2), hjust = 0.5),
    panel.border = element_rect(colour = NA),
    axis.title = element_text(face = "bold",size = rel(1)),
    axis.title.y = element_text(angle=90,vjust =2),
    axis.title.x = element_text(vjust = -0.2),
    axis.text = element_text(),
    axis.line = element_line(colour="black"),
    axis.ticks = element_line(),
    legend.key = element_rect(colour = NA),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.key.size = unit(0.45, "cm"),
    legend.margin = unit(0.3, "cm"))
}

scale_colour_1 <- function(...){
  library(scales)
  discrete_scale("colour","Col1",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#31a354")))
}

scale_colour_2 <- function(...){
  library(scales)
  discrete_scale("colour","Col2",manual_pal(values = c("#a6cee3","#fb9a99","#984ea3","#662506")))
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
    stop("Usage analyseResults.R <dataFile> <applicationName>")
}

inputFile = args[1]
appName   = args[2]

expectedSamples = 10

# Data format:
# variant benchmark hosts processes schedulers cores workers runtime
data <- read.table(inputFile, header = T)

# Speedup Tables/Plots
scaling <- data %>%
  group_by(benchmark, variant, workers) %>%
  summarise(runtimeM = mean(runtime)) %>%
  group_by(benchmark, variant) %>%
  mutate(speedup = runtimeM[workers == 1] / runtimeM)

# Remove anything with NA's from both sets of scaling runs
tmp <- scaling %>% filter(is.na(runtimeM))
missingBenchmarks <- unique(tmp$benchmark)
scaling <- scaling %>% filter(!benchmark %in% missingBenchmarks)

maxSpeedup = max(scaling$speedup)

# Split data into two sets to make it easier to see in the graph
names <- as.list(levels(scaling$benchmark))
benchmarkNames <- split(names, c(1,2))

i = 0
plots <- vector()
for (n in benchmarkNames) {
  #Different colours per plot to avoid confusion
  if (i == 0) { pal = scale_colour_1 } else { pal = scale_colour_2 }
  plts <- scaling %>% group_by(variant) %>% filter(benchmark %in% n) %>%
    do (plot = ggplot(data=., aes(x = workers, y = speedup, colour = benchmark, linetype = benchmark))
            + geom_line(size = 1.2)
            + ggtitle(.$variant)
            + xlab("Workers")
            + ylab("Speedup")
            + scale_y_continuous(limits = c(-3, maxSpeedup + 5), expand = c(0,0))
            + scale_x_continuous(limits = c(-3, 205), expand = c(0,0))
            + theme_publication()
            + pal()
            + guides(colour = guide_legend(nrow = 2, byrow = T))
      )
  plots <- c(plots, plts$plot[1], plts$plot[2])
  i = i + 1
}

# Make quad plots of the data
title <- ggdraw() + draw_label(paste0(appName, "  Speedup"))

grid <- plot_grid(plots[[1]] + theme(legend.position = "none"),
                  plots[[3]] + theme(legend.position = "none"),
                  plots[[2]] + theme(legend.position = "none"),
                  plots[[4]] + theme(legend.position = "none"),
                  nrow = 2)

# Legend is obvious from the context
l1 <- get_legend(plots[[1]] + theme(legend.title = element_blank()))
l2 <- get_legend(plots[[3]] + theme(legend.title = element_blank()))
legends <- plot_grid(l1, l2, nrow = 1, rel_widths = c(0.5, 0.5))

finalPlot <- plot_grid(title, grid, legends, ncol = 1, rel_heights = c(0.1, 1, 0.1))

postscript(file = paste0("speedup-", gsub(" ","",appName), ".eps"),
           horizontal = F,
           onefile = F,
           paper = "special",
           width=10,
           height=10)
print(finalPlot)
dev.off()

# CDF repeatability measure
relSD <- data %>% group_by(benchmark, variant, workers) %>%
  filter (!is.na(runtime))                              %>%
  summarise(runtimeM  = mean(runtime),
            runtimeSD = sd(runtime),
            relsd     = (runtimeSD / runtimeM) * 100)

maxRSD = max(relSD$relsd)

# We only take samples with a mean runtime > 5s to avoid high relSD's due to low
# setup to run ratios
plts <- relSD %>% filter(runtimeM > 5) %>% filter (workers %in% c(1, 8, 64, 200)) %>% group_by(workers) %>%
  do (plot = ggplot(data=., aes(x = relsd, colour = variant, linetype = variant))
           + stat_ecdf(geom = "step", size = 1.2)
           + ggtitle(paste0(.$workers, " Workers"))
           + xlab("Rel SD (%)")
           + xlim(c(-20, maxRSD + 20)) # ggplot likes padding either end (it draws tails)
           + ylab("Probability")
           + theme_publication()
     )

# Make quad plots of the data
title <- ggdraw() + draw_label(paste0(appName, " - RSD CDF"))
grid <- plot_grid(plts$plot[[1]] + theme(legend.position = "none"),
                 plts$plot[[2]] + theme(legend.position = "none"),
                 plts$plot[[3]] + theme(legend.position = "none"),
                 plts$plot[[4]] + theme(legend.position = "none"),
                 nrow = 2)
legend <- get_legend(plts$plot[[1]])
finalPlot <- plot_grid(title, grid, legend, ncol = 1, rel_heights = c(0.1, 1, 0.1))

postscript(file = paste0("relsd-",gsub(" ","",appName),".eps"),
           horizontal = F,
           onefile = F,
           paper = "special",
           width=10,
           height=10)
print(finalPlot)
dev.off()
