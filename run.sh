#!/bin/bash

set -m

# Generate certificate
if [ ! -f /.certificate_created  ]; then
  /create_certificate.sh
fi

# Start riak
supervisord -n &

# Generate riak user
if [ ! -f /.riak_password_set ]; then
  /set_riak_password.sh
fi

# Print riak logs to stdout
tail -F /var/log/riak/*.log &

fg %1
