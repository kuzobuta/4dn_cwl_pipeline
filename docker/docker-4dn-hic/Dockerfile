#Updates & Modified by Hisashi Miura (hisashi.miura@riken.jp)
#ver. 240708 for non-default channel in miniconda2
FROM duplexa/4dn-hic:v43
MAINTAINER Hisashi Miura (hisashi.miura@riken.jp), Original file from Soo Lee (duplexa@gmail.com)
LABEL version="v43.1_hm"

# update miniconda2
COPY Miniconda2-4.6.14-Linux-x86_64.sh .
RUN bash Miniconda2-4.6.14-Linux-x86_64.sh -p /miniconda2 -b -u
RUN conda config --add channels conda-forge
RUN conda config --remove channels defaults
RUN conda config --set channel_priority strict
RUN conda update -y --all
RUN rm Miniconda2-4.6.14-Linux-x86_64.sh

# wrapper
COPY new_scripts/ .
RUN chmod +x run*.sh

# default command
CMD ["run-list.sh"]
