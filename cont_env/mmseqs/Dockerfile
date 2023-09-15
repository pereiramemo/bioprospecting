FROM ubuntu:22.04

RUN mkdir -p /output/
RUN mkdir -p /input/
RUN mkdir -p /resources/

RUN apt-get update; \
  apt-get update && apt-get install -y \
    git \
    wget \
    build-essential \
    cmake \
    ncbi-blast+ \
    zlib1g-dev
  
RUN git clone https://github.com/soedinglab/MMseqs2.git; \
  cd MMseqs2; \
  mkdir build; \
  cd build; \
  cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=. ..; \
  make; \
  make install
    
RUN MMseqs2/build/bin/mmseqs databases UniProtKB/Swiss-Prot /resources/siwss_prot tmp

ENTRYPOINT ["/MMseqs2/build/bin/mmseqs"]