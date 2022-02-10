#!/usr/bin/env bash

# This sets iptables rules that facilitate targeted dropping of connections for
# the reconnect tests.

iptables-restore -v -t <<RULES
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3891 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3890 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
-A INPUT -p tcp -m tcp --dport 6360 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -j REJECT --reject-with tcp-reset
-A OUTPUT -p tcp -m tcp --sport 22 -j ACCEPT
-A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
-A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -j REJECT --reject-with tcp-reset
COMMIT
RULES
