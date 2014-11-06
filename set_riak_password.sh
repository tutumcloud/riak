#!/bin/bash

if [ -f /.riak_password_set ]; then
  echo "riak password already set!"
  exit 0
fi

# Generate random password for riakuser or use ENV password
PASS=${RIAK_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${RIAK_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating riak user with ${_word} password"

# Enable security for use authentication user and create user with random password
riak-admin security enable
riak-admin security add-user riakuser password=$PASS
riak-admin security grant riak_core.set_bucket,riak_kv.get,riak_kv.put,riak_kv.delete,riak_kv.index,riak_kv.list_keys,riak_kv.list_buckets on any to riakuser
riak-admin security add-source all 0.0.0.0/0 password

echo "=> Done!"
touch /.riak_password_set

echo "========================================================================"
echo "You can now use riak Server using:"
echo ""
echo "  wget --no-check-certificate -qO- https://riakuser:$PASS@host:port/ping"
echo ""
echo "Or use protocol buffer with same user/password."
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "You must use https protocol. http is disable for security reasons"
echo "========================================================================"
