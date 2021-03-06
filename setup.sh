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


VIRSHCMD="virsh -c qemu:///system"
FORCE=0

function start_cluster {

    terraform plan
    terraform apply

    if [ "$FORCE" == "1" ]; then
        start_inactive_vms
    fi
}

function destroy_cluster {

    terraform refresh
    terraform destroy

    echo "Warning: Destroy may not function as expected."
    echo "Note: You may have to do some manual cleanups using virsh."

    if [ "$FORCE" == "1" ]; then
        destroy_remaining_vms
    fi
}

function destroy_remaining_vms {

    # XXX dbite: Fix it in the right place.
    # Temporary hack!
    active_vms=$($VIRSHCMD list |\
        tail -n +3 |\
        grep -E "running|dsaltmaster|dsaltminion-[0-9]" |\
        awk '{ print$2 }')

    printf "Found the following VM's to be active:\n$active_vms\n"
    echo "Manually stopping VM's."

    for vm in $active_vms ; do
        echo "Stopping and destroying $vm."
        $VIRSHCMD destroy $vm
        sleep 2
        $VIRSHCMD undefine $vm
        sleep 3
    done
}

function start_inactive_vms {

    # XXX dbite: Fix this issue in the right place.
    # Quick hack for this issue:
    # https://github.com/dmacvicar/terraform-provider-libvirt/issues/65

    # Search for inactive VM's which are created by this program.
    # Really really make sure that the VM's belong to this cluster.
    # Logic is flawed since it is very specific to the VM naming scheme
    # of `libvirt.tf` configuration file.
    inactive_vms=$($VIRSHCMD list --all |\
        tail -n +3 |\
        grep -v "running" |\
        awk '{ print $2 }' |\
        grep -E "dsaltmaster|dsaltminion-[0-9]")

    printf "Found the following VM's to be inactive:\n$inactive_vms\n"
    echo "Manually Starting inactive VMs."

    for vm in $inactive_vms ; do
        echo "Starting $vm."
        $VIRSHCMD start $vm
        sleep 5
    done
}

function usage {
    echo "Usage: $0 [-f] [h|help|provision|teardown]"
    echo
    echo "-f            Force, manually trigger libvirt after terraform"
    echo "              has run. WARNING! This will break terraform."
    echo
    echo "h|help        Help."
    echo "provision     Provision the salt cluster using terraform."
    echo "teardown      Destroy the cluster, additionally attempt cleanups."
    echo
    echo "Please retry with the above mentioned options. Have fun hacking!"
    exit
}

function cli {
    case $OPTIONS in
        h|help)
            usage
            ;;
        provision)
            start_cluster
            exit
            ;;
        teardown)
            # XXX terraform libvirt is not a good citizen for destroy.
            destroy_cluster
            exit
            ;;
        *)
            echo "Invalid Option(s) $OPTIONS."
            usage
            ;;
    esac
}

OPTIONS=$@
if [ $# -eq 0 ]; then
    usage
else
    if [ "$1" == "-f" ]; then
        shift
        FORCE=1
    fi
    OPTIONS=$1
    cli $OPTIONS
fi
