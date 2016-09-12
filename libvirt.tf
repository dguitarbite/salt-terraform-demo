provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "opensuse_leap" {

    name = "opensuse_leap"
    source = "http://download.opensuse.org/repositories/Cloud:/Images:/Leap_42.1/images/openSUSE-Leap-42.1-OpenStack.x86_64.qcow2"

}

resource "libvirt_cloudinit" "commoninit" {

    name = "commoninit.iso"
    local_hostname = "tfsaltdemo"
    ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwxtBlrwiGRN9LUsbkVYcDah2Q+BduBWQH5/jryqORyeBIy4iYWqnzIpc+bz+fNr0t7jvv/f4B0c4TT65bgyfoyjy6kDhMQ9K4JnR2LeKH3wtE2ff9+4FyweONyrxB/GQyY51zGBX+qEdyidrt3I4dHh0libbekokmDb+xRTWdLABi9tXP7nMfBm08ML2S/+UcCyZqtSoDlVmXU6lIpf9CiWAQEPymEE5nB0hplMvzCz0jCzgBBu1wgEfPeMMjgHGRtUr6ESzJIm1zJTPpn3evHas30iIxqUW3OmqGaaWK1QIBfnP+fw+Q8YLPu24Mk2Cs2lDZfa3xUXSVCHzJ34Yh pranav@pranavws"
}

resource "libvirt_network" "tfsaltdemo" {

    name = "tfsaltdemo"
    mode = "nat"
    domain = "tfsaltdemo.local"
    addresses = ["10.5.4.0/24"]
}

resource "libvirt_volume" "mastervolume" {

    name = "dsaltmastervol"
    base_volume_id = "${libvirt_volume.opensuse_leap.id}"
}

resource "libvirt_volume" "minionvolume" {

    name = "dsaltminionvol-${count.index}"
    base_volume_id = "${libvirt_volume.opensuse_leap.id}"
    count = 2
}

resource "libvirt_domain" "saltmaster" {

    name = "dsaltmaster"
    disk {
        volume_id = "${libvirt_volume.mastervolume.id}"
    }
    network_interface {
        network_id = "${libvirt_network.tfsaltdemo.id}"
        hostname = "saltmaster"
        addresses = ["10.5.4.3"]
        wait_for_lease = 1
    }
    cloudinit = "${libvirt_cloudinit.commoninit.id}"
    count = 1
    provisioner "local-exec" {
        command = "echo 'Hello'"
    }
}

resource "libvirt_domain" "saltminion" {

    name = "dsaltminion-${count.index}"
    disk {
        volume_id = "${element(libvirt_volume.minionvolume.*.id, count.index)}"
    }
    network_interface {
        network_id = "${libvirt_network.tfsaltdemo.id}"
        hostname = "saltminion${count.index}"
        addresses = ["10.5.4.${count.index+4}"]
        wait_for_lease = 1
    }
    cloudinit = "${libvirt_cloudinit.commoninit.id}"
    count = 2
    provisioner "local-exec" {
        command = "echo 'Hello'"
    }
}

output "master" {

    value = "${libvirt_domain.saltmaster.ip}"
}

output "minions" {

    value = "${libvirt_domain.saltminion.ip}"
}
