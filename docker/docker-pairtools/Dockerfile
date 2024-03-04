#New version of pairtools & copy the scripts
FROM quay.io/biocontainers/pairtools:1.0.3--py39h9e08559_0
MAINTAINER Hisashi Miura (hisashi.miura@riken.jp) 
LABEL version="v1.0.3"

# wrapper
WORKDIR /usr/local/bin
COPY scripts/ .
RUN chmod +x *.sh
RUN chmod +x *.py

# default command
CMD ["bash"]
