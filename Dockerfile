FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get install -y redsocks iptables && mkdir /etc/redsocks

# Copy configuration files...
COPY redsocks.tmpl /etc/redsocks.tmpl
COPY whitelist.txt /etc/redsocks/whitelist.txt
COPY redsocks.sh /usr/local/bin/redsocks.sh
COPY redsocks-fw.sh /usr/local/bin/redsocks-fw.sh

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/redsocks.sh"]
