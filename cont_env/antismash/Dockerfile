FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
	python3-pip \
	git \
  apt-transport-https \
  wget
  
RUN wget http://dl.secondarymetabolites.org/antismash-stretch.list -O /etc/apt/sources.list.d/antismash.list
RUN wget -q -O- http://dl.secondarymetabolites.org/antismash.asc | apt-key add -
RUN apt-get update && apt-get install -y \
  hmmer2 \
  hmmer \
  diamond-aligner \
  fasttree \
  prodigal \
  ncbi-blast+ \
  muscle \
  glimmerhmm

ENV version=7.0.0

RUN wget https://dl.secondarymetabolites.org/releases/${version}/antismash-${version}.tar.gz
RUN tar -zxf antismash-${version}.tar.gz
RUN pip install ./antismash-${version}
RUN download-antismash-databases

# ENTRYPOINT ["/usr/local/bin/antismash"]
