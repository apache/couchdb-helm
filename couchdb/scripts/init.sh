#!/usr/bin/env sh
set -eo pipefail
# need to build a .netrc file in our RAM disk (/tmp) in such a way credentials do not leak to the process table
# netrc has the format of 'machine <hostname> login <username> password <password>'

# slice the port from couch address off so netrc matching works
echo -n "machine $COUCHDB_ADDRESS" | cut -d':' -f1 >> /tmp/.netrc
echo -n " login " >> /tmp/.netrc
# cat the contents of the secret file, strip any new lines, redirect the output to be appended to the .netrc file
cat $COUCHDB_ADMIN_PATH | tr -d '\n' >> /tmp/.netrc
echo -n " password " >> /tmp/.netrc
cat $COUCHDB_PASS_PATH | tr -d '\n' >> /tmp/.netrc

set -x

curl --netrc-file /tmp/.netrc --fail -s http://$COUCHDB_ADDRESS/_cluster_setup -X POST -H "Content-Type: application/json" -d "{\"action\": \"finish_cluster\"}"
export IFS=","
for db_name in $DEFAULT_DBS
do
    curl --netrc-file /tmp/.netrc --fail -X PUT http://$COUCHDB_ADDRESS/$db_name
done
