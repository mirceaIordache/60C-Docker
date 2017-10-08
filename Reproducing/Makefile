ALL_OUTPUTS = maxclique-runtime-comparison.tex fg-h44-table.tex \
							htsl-maxclique-speedups.pdf ctsl-maxclique-speedups.pdf

.PHONY : all clean
all : $(ALL_OUTPUTS)

clean :
	rm $(ALL_OUTPUTS)

# Produce Content for Table 2
maxclique-runtime-comparison.tex: scripts/maxclique-compare-runtime.R maxclique-ctsl.dat maxclique-htsl.dat graph_info.dat
	Rscript scripts/maxclique-compare-runtime.R maxclique-ctsl.dat maxclique-htsl.dat graph_info.dat 

# Produce Content for Table 4
fg-h44-table.tex: scripts/tabularise-h44-existence-runtimes.R existence-h44-ctsl.dat existence-h44-htsl.dat
	Rscript scripts/tabularise-h44-existence-runtimes.R existence-h44-ctsl.dat existence-h44-htsl.dat
	
# Produce Figure 3
htsl-maxclique-speedups.pdf : maxclique-htsl.dat scripts/plot-speedups.R
	Rscript scripts/plot-speedups.R maxclique-htsl.dat "htsl"
	
# Produce Figure 4
ctsl-maxclique-speedups.pdf : maxclique-ctsl.dat scripts/plot-speedups.R
	Rscript scripts/plot-speedups.R maxclique-ctsl.dat "ctsl"
	