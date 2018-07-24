#!/usr/bin/env bash
ECHO=$(which echo)
NSUPDATE=$(which nsupdate)

#bind key file to use
KEY="/etc/named/keys/dyn_dns_host.key"

#which host to update
HOST="dyn.myhost.tld."
ZONE="myhost.tld."

#which server to send the request to
SERVER="ns1.mydomain.tld"

IP6=`curl -s https://ipv6.nsupdate.info/myip`
OLDIP6=`dig $HOST AAAA +short @8.8.8.8`
IP4=`curl -s https://ipv4.nsupdate.info/myip`
OLDIP4=`dig $HOST A +short @8.8.8.8`

$ECHO "Current IPv6: $IP6"
$ECHO "Current IPv4: $IP4"

$ECHO "Checking AAAA record for $HOST"
if [ "$IP6" != "$OLDIP6" ];
 then
  $ECHO "server $SERVER" > /tmp/nsupdate-dual-6
  $ECHO "debug yes" >> /tmp/nsupdate-dual-6
  $ECHO "zone $ZONE" >> /tmp/nsupdate-dual-6
  $ECHO "update delete $HOST AAAA" >> /tmp/nsupdate-dual-6
  $ECHO "update add $HOST 1800 AAAA $IP6" >> /tmp/nsupdate-dual-6
  $ECHO "send" >> /tmp/nsupdate-dual-6
  $ECHO "AAAA record is stale"
  $NSUPDATE -k ${KEY} -v /tmp/nsupdate-dual-6 >> /var/log/nsupdate-dual_dyn.log 2>&1
  rm -rf /tmp/nsupdate-dual-6
 else
  $ECHO "No AAAA record update needed"
fi

$ECHO "Checking A record for $HOST"
if [ "$IP4" != "$OLDIP4" ];
 then
  $ECHO "server $SERVER" > /tmp/nsupdate-dual-4
  $ECHO "debug yes" >> /tmp/nsupdate-dual-4
  $ECHO "zone $ZONE" >> /tmp/nsupdate-dual-4
  $ECHO "update delete $HOST A" >> /tmp/nsupdate-dual-4
  $ECHO "update add $HOST 1800 A $IP4" >> /tmp/nsupdate-dual-4
  $ECHO "send" >> /tmp/nsupdate-dual-4
  $ECHO "A record is stale"
  $NSUPDATE -k ${KEY} -v /tmp/nsupdate-dual-4 >> /var/log/nsupdate-dual_dyn.log 2>&1
  rm -rf /tmp/nsupdate-dual-4
  $ECHO "Exiting"
  exit 1
 else
  $ECHO "No A record update needed..."
fi

$ECHO "Exiting"
exit 0