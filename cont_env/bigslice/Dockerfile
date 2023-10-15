FROM ubuntu:22.04

RUN mkdir -p /output/
RUN mkdir -p /input/
RUN mkdir -p /resources/

RUN apt-get update; \
  apt-get install -y \
  python3.9 \
  python3-pip \
  git \
  hmmer

RUN git clone https://github.com/pereiramemo/bigslice
RUN cd ./bigslice; \
    pip3 install ./
RUN download_bigslice_hmmdb https://s3.amazonaws.com/share.jgi-ga.org/satria/bigslice-models.2022-11-30.tar.gz
RUN rm bigslice_models.tar.gz

RUN ls ./usr/local/bin/bigslice-models/sub_pfams/hmm/*.hmm | \
  while read LINE; do \
    hmmpress "${LINE}"; \ 
  done

ENTRYPOINT ["/usr/local/bin/bigslice"]
