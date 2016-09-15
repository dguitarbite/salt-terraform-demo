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

zypper in -ly salt-minion

# Salt minion configuration.
wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/utils/files/minion -O /tmp/saltminion
cat /tmp/saltminion > /etc/salt/minion

systemctl enable salt-minion.service
systemctl start salt-minion.service
