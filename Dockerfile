FROM ubuntu:trusty
MAINTAINER Israel Gayoso igayoso@gmail.com 

# Update the APT cache, add basho's repository and install packages
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update && \
  apt-get install -y apt-transport-https openssl pwgen

# Add riak's repository and install
ADD ./basho.apt.key /tmp/basho.apt.key
RUN apt-key add /tmp/basho.apt.key && rm /tmp/basho.apt.key
RUN echo "deb https://packagecloud.io/basho/riak/ubuntu/ trusty main" > /etc/apt/sources.list.d/basho.list
RUN apt-get update && apt-get install riak

# Riak's config 
ENV RIAK_NODE_NAME "127.0.0.1"
ADD ./app.config /etc/riak/app.config
RUN sed -i -e s/riak_kv_bitcask_backend/riak_kv_eleveldb_backend/g /etc/riak/app.config
RUN sed -i -e 0,/"enabled, false"/{s/"enabled, false"/"enabled, true"/} /etc/riak/app.config
RUN sed -i -e s/listener.http.internal/listener.https.internal/g /etc/riak/riak.conf

# Copy init script to make configuration after first run and password set
ADD ./run.sh /run.sh
ADD ./set_riak_password.sh /set_riak_password.sh
ADD ./create_certificate.sh /create_certificate.sh

# Expose protocol buffers and HTTPS
EXPOSE 8087 8098

CMD ["/run.sh"]
