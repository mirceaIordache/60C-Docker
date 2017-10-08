Data from "Towards Generic Scalable Parallel Combinatorial Search" to appear in
PASCO 2017.

Authors: Blair Archibald, Patrick Maier, Robert Stewart, Phil Trinder and Jan De Beule

Results are stored in space-separated value (ssv) format. 

The plots and table data from the paper may be reproduced using the analysis
scripts in the scripts directory. A Makefile is provided to automate the process
and show the required commands. The scripts depend on R with the xtable, ggplot2
and dplyr packages available.

Setup
======

All experiments are run on a the University of Glasgow GPG cluster with the following spec:

1.  20 Nodes (Max 17 used)
2.  16 Intel cores/node (2 \* Intel Xeon E5-2640 2GHz)
3.  64Gb RAM per node, i.e. 4Gb RAM/core.
4.  Local Disk: 300Gb/node
5.  10Gb Ethernet Interconnect
6.  Ubuntu 14.04, Linux 3.19

Source code for the applications is available at:

HTSL: https://doi.org/10.5281/zenodo.556548 
CTSL: https://doi.org/10.5281/zenodo.556546

existence-h44-ctsl.dat
===========================

CTSL Version: 7518fbfe76a7b0df906bcc8a9d9995d8aa4be45a 
HPX Version: b95a17cfa93e2f4a02fb4473b2e5fe44ba4c1261 
gcc Version: 6.3.0
Spawndepth: Two from root node

  Field            Type    Desc
  ---------------- ------- ---------------------------------------------------------------------
  hosts            int     Number of distributed hosts we run on
  processes        int     Number of OS processes we spawn. Round robin distributed over hosts
  workersPerProc   int     Number of threads we allocate to executing search work per process
  totalWorkers     int     processes * workersPerProc
  runtime          float   Total program runtime in seconds as given by /usr/bin/time
  exists           bool    Did we find a spread in H(4,4)?

existence-h44-htsl.dat
============================

GHC Version: 8.0.1 
HTSL/maxclique Version: 6d96d6bc27b026388949a6ab3298f4ad9e202780
Spawndepth: Two from root node

  Field            Type    Desc
  ---------------- ------- --------------------------------------------------------------------------------
  hosts            int     Number of distributed hosts we run on
  processes        int     Number of OS processes we spawn. Round robin distributed over hosts
  workersPerProc   int     Number of threads we allocate as HdpH schedulers per process
  totalWorkers     int     processes * workersPerProc
  runtime          float   Runtime to perform search in seconds as reported by the program at termination
  exists           bool    Did we find a spread in H(4,4)?

maxclique-htsl.dat
=======================

GHC Version: 8.0.1 
HTSL/maxclique Version: 6d96d6bc27b026388949a6ab3298f4ad9e202780 
Spawndepth: Two from root node

  Field          Type    Desc
  -------------- ------- ----------------------------------------------------------------------------
  instance       str     DIMACS instance name
  hosts          int     Number of distributed hosts we run on
  processes      int     Number of OS processes we spawn. Round robin distributed over hosts
  schedulers     int     Number of HdpH scheduler threads a.k.a Workers
  cores          int     Number of OS threads assigned to each process
  totalWorkers   int     processes * schedulers
  runtime        float   Runtime to perform search in seconds as reported by program at termination

maxclique-ctsl.dat
=====================

CTSL Version: 7518fbfe76a7b0df906bcc8a9d9995d8aa4be45a 
HPX Version: b95a17cfa93e2f4a02fb4473b2e5fe44ba4c1261
gcc Version: 6.3.0
Spawndepth: Two from root node

  Field            Type    Desc
  ---------------- ------- ----------------------------------------------------------------------------
  instance         str     DIMACS instance name
  hosts            int     Number of distributed hosts we run on
  processes        int     Number of OS processes we spawn. Round robin distributed over hosts
  threads          int     OS threads allocated to a HPX instance
  workersPerProc   int     Number of threads we allocate to executing search work per process
  totalWorkers     int     processes * schedulers
  runtime          float   Runtime to perform search in seconds as reported by program at termination
  maxclique        int     Size of the discovered maximum clique
