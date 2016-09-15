#!/bin/bash
#============================================================================
#
#   USAGE: ./setup.sh
#   DESCRIPTION: Automatically setup the cluster and tear it down.
#
#============================================================================

set -o nounset                      # Treat unset variables as an error.

trap 'kill -- -$$' SIGINT           # Kill entire process group.

#============================================================================

zypper in -ly salt-master

# Get the salt configuration files
wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/utils/files/master -O /tmp/saltmaster
cat /tmp/saltmaster > /etc/salt/master

# Create required folders!
mkdir -p /srv/formulas

# Fetch salt rabbit-formula to /srv/formulas
git clone https://github.com/dguitarbite/rabbitmq-formula.git /srv/formulas/rabbit-formula

# Fetch the salt modules from my repo.
# XXX(dbite): Find more elegant method.
wget https://github.com/dguitarbite/salt-terraform-demo/archive/master.zip
unzip master.zip
mv salt-terraform-demo-master/salt/* /srv/.
chown -R root:salt /srv/salt /srv/pillar

systemctl enable salt-master.service
systemctl start salt-master.service
