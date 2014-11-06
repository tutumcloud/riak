#!/bin/bash

# Generate new autosigned certificate by our own CA
echo "=> Generating certificate"
openssl genrsa -out /etc/riak/rootCA.key 2048 && openssl req -subj '/CN=0.0.0.0/O=Riak/C=US' -x509 -new -nodes -key /etc/riak/rootCA.key -days 365 -out /etc/riak/rootCA.crt
openssl genrsa -out /etc/riak/host.key 2048 && openssl req -subj '/CN=0.0.0.0/O=Riak/C=US' -new -key /etc/riak/host.key -out /etc/riak/host.csr && openssl x509 -req -in /etc/riak/host.csr -CA /etc/riak/rootCA.crt -CAkey /etc/riak/rootCA.key -CAcreateserial -out /etc/riak/host.crt -days 365

echo "=> Done!"
touch /.certificate_created
