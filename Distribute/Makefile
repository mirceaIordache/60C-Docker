.PHONY: figures clean

ANALYSIS_SCRIPT = scripts/analyseResults.R
SCATTER_ANALYSIS_SCRIPT = scripts/plotScalingScatter.R

ALL_FIGURES = relsd-MaximumClique.eps speedup-MaximumClique.eps \
							relsd-Knapsack.eps speedup-Knapsack.eps \
							relsd-TSP.eps speedup-TSP.eps

figures: $(ALL_FIGURES)

clean:
	rm *.eps

relsd-MaximumClique.eps speedup-MaximumClique.pdf: maxclique.dat $(ANALYSIS_SCRIPT)
	Rscript $(ANALYSIS_SCRIPT) $< "Maximum Clique"

relsd-Knapsack.eps speedup-Knapsack.pdf: knapsack.dat $(ANALYSIS_SCRIPT)
	Rscript $(ANALYSIS_SCRIPT) $< "Knapsack"
	
relsd-TSP.eps speedup-TSP.pdf: tsp.dat $(ANALYSIS_SCRIPT)
	Rscript $(ANALYSIS_SCRIPT) $< "TSP"
	
$(MC-SCATTER-SCALING-FIGURES): maxclique.dat $(SCATTER_ANALYSIS_SCRIPT)
	Rscript $(SCATTER_ANALYSIS_SCRIPT) $< "brock400_3"
	mv brock400_3-Ordered-sampled.pdf
	mv brock400_3-Unordered-sampled.pdf
