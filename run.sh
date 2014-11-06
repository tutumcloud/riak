#!/bin/bash

# Generate certificate
if [ ! -f /.certificate_created  ]; then
  /create_certificate.sh
fi

# Start riak
/usr/sbin/riak start
#/etc/init.d/riak start

# Generate riak user
if [ ! -f /.riak_password_set ]; then
  /set_riak_password.sh
fi

# Atach to riak console or show log for don't stop container
tail -f /var/log/riak/*.log
