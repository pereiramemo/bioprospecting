FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
	python3-pip \
	git \
&& rm -rf /var/lib/apt/lists/
RUN git clone https://github.com/medema-group/bigslice.git
RUN cd ./bigslice && git checkout 1ccd095cda3e3f36eeb9bbddc7a7a84db2b9722c
RUN pip install ./bigslice/

RUN download_bigslice_hmmdb https://github.com/medema-group/bigslice/releases/download/v1.0.0/bigslice-models.2020-04-27.tar.gz

RUN mkdir -p /output/
RUN mkdir -p /input/
RUN mkdir -p /resources/

RUN apt-get update && apt-get install -y hmmer

ENTRYPOINT ["/usr/local/bin/bigslice"]
