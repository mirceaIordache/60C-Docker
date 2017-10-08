FROM 60c:initial
MAINTAINER 60C Docker Workshop

RUN apt-get update && apt-get install -y \
        r-cran-gridbase r-cran-gridextra wget && \
        wget https://cran.csiro.au/src/contrib/cowplot_0.8.0.tar.gz \
        && R CMD INSTALL cowplot_0.8.0.tar.gz 

RUN mkdir -p /opt/graphs/scripts && mkdir -p /opt/graphs/results

ADD knapsack.dat /opt/graphs
ADD maxclique.dat /opt/graphs
ADD maxclique-sequential-cpp.dat /opt/graphs
ADD maxclique-sequential-haskell.dat /opt/graphs
ADD scaling-Knapsack.dat /opt/graphs
ADD scaling-MaximumClique.dat /opt/graphs
ADD scaling-TSP.dat /opt/graphs
ADD tsp.dat /opt/graphs

ADD scripts/analyseResults.R /opt/graphs/scripts
ADD scripts/plotScalingScatter.R /opt/graphs/scripts

ADD Makefile /opt/graphs
ADD README /opt/graphs

ENTRYPOINT make -C /opt/graphs figures && /bin/bash