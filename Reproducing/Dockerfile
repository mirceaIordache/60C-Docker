FROM debian:stretch
MAINTAINER Mircea Iordache

RUN apt-get update && apt-get install -y \
		r-base r-cran-xtable r-cran-ggplot2 \
		r-cran-dplyr r-cran-tidyr
		
RUN mkdir -p /opt/skel

ADD existence-h44-ctsl.dat /opt/skel
ADD existence-h44-htsl.dat /opt/skel
ADD graph_info.dat /opt/skel
ADD maxclique-ctsl.dat /opt/skel
ADD maxclique-htsl.dat /opt/skel

ADD scripts.zip /opt/skel

ADD Makefile /opt/skel

ADD README.md /opt/skel

RUN unzip /opt/skel/scripts.zip -d /opt/skel
RUN mkdir -p /opt/skel/results

ENTRYPOINT make -C /opt/skel all && /bin/bash