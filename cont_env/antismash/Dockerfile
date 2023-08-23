FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
	python3-pip \
	git \
  apt-transport-https 
  
RUN wget http://dl.secondarymetabolites.org/antismash-stretch.list -O /etc/apt/sources.list.d/antismash.list
RUN wget -q -O- http://dl.secondarymetabolites.org/antismash.asc | sudo apt-key add -
RUN apt-get update && apt-get install -y \
  hmmer2 \
  hmmer \
  diamond-aligner \
  fasttree \
  prodigal \
  ncbi-blast+ \
  muscle \
  glimmerhmm

RUN wget https://dl.secondarymetabolites.org/releases/5.1.1/antismash-5.1.1.tar.gz; \
tar -zxf antismash-5.1.1.tar.gz


# ENTRYPOINT ["/usr/local/bin/antismash"]
