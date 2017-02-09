#!/bin/sh

##########################
# Setup the Firewall rules
##########################
fw_setup() {
  # First we added a new chain called 'REDSOCKS' to the 'nat' table.
  iptables -t nat -N REDSOCKS

  # Next we used "-j RETURN" rules for the networks we don’t want to use a proxy.
  while read item; do
      iptables -t nat -A REDSOCKS -d $item -j RETURN
  done < /etc/redsocks/whitelist.txt

  iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

  # Finally we tell iptables to use the ‘REDSOCKS’ chain for all outgoing connection in the virtual bridge ‘docker0'
  iptables -t nat -A PREROUTING -i docker0 -p tcp -j REDSOCKS
}

##########################
# Clear the Firewall rules
##########################
fw_clear() {
  iptables-save | grep -v REDSOCKS | iptables-restore
}

case "$1" in
    start)
        echo -n "Setting REDSOCKS firewall rules..."
        fw_clear
        fw_setup
        echo "done."
        ;;
    stop)
        echo -n "Cleaning REDSOCKS firewall rules..."
        fw_clear
        echo "done."
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
exit 0

