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

function start_cluster {

    terraform plan
    terraform apply
}

function destroy_cluster {

    terraform refresh
    terraform destroy
    echo "Warning: Destroy may not function as expected."
    echo "Note: You may have to do some manual cleanups using vish."
    destroy_remaining_vms
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
    echo "Usage: $0 [h|help|setup|teardown]"
    echo
    echo "h|help        Help."
    echo "setup         Setup the salt cluster using terraform."
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
        setup)
            start_cluster
            start_inactive_vms
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
shift $(( OPTIND -1 ))
if [ $# -eq 0 ]; then
    usage
else
    cli $OPTIONS
fi
