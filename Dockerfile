FROM ubuntu:20.04

# Set timezone in tzdata
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

# Install required packages
RUN apt-get update
RUN apt-get install -y build-essential wget autoconf

# Install dependencies for AUGUSTUS comparative gene prediction mode (CGP)
RUN apt-get install -y libgsl-dev libboost-all-dev libsuitesparse-dev liblpsolve55-dev
RUN apt-get install -y libsqlite3-dev libmysql++-dev

# Install dependencies for the optional support of gzip compressed input files
RUN apt-get install -y libboost-iostreams-dev zlib1g-dev

# Install dependencies for bam2hints and filterBam 
RUN apt-get install -y libbamtools-dev

# Install additional dependencies for bam2wig
RUN apt-get install -y samtools libhts-dev

# Install additional dependencies for homGeneMapping and utrrnaseq
RUN apt-get install -y libboost-all-dev

# Install hal - required by homGeneMapping 
# execute the commented out code if you want to use this program - see auxprogs/homGeneMapping/Dockerfile
#RUN apt-get install -y libhdf5-dev pkg-config
#WORKDIR /root/sonLib
## 2020-11-16 snapshot
#RUN wget -O - https://github.com/ComparativeGenomicsToolkit/sonLib/archive/dd3aa0c.tar.gz | tar --strip-components=1 -xzf -
#RUN make -j
#WORKDIR /root/hal
# 2020-08-21 snapshot
#RUN wget -O - https://github.com/ComparativeGenomicsToolkit/hal/archive/f8f3fa2.tar.gz | tar --strip-components=1 -xzf -
#RUN make -j
#ENV PATH="${PATH}:/root/hal/bin"

# Clone AUGUSTUS repository
ADD / /root/augustus

# Build AUGUSTUS
WORKDIR "/root/augustus"
RUN make clean
RUN make
RUN make install
ENV PATH="/root/augustus/bin:${PATH}"

# Test AUGUSTUS
RUN make unit_test
