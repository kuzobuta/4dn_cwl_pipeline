#Updates & Modified by Hisashi Miura (hisashi.miura@riken.jp)
#ver. 240229
FROM duplexa/4dn-hic:v43
MAINTAINER Hisashi Miura (hisashi.miura@riken.jp), Original file from Soo Lee (duplexa@gmail.com)
LABEL version="v43_hm"

# wrapper
COPY new_scripts/ .
RUN chmod +x run*.sh

# default command
CMD ["run-list.sh"]
