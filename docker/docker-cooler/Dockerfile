#Update version of cooler for docker-4dn-hic analysis
FROM quay.io/biocontainers/cooler:0.9.3--pyhdfd78af_0
MAINTAINER Hisashi Miura (hisashi.miura@riken.jp) 
LABEL version="v0.9.3"

# wrapper
WORKDIR /usr/local/bin
COPY scripts/ .
RUN chmod +x run*.sh

# default command
CMD ["bash"]
