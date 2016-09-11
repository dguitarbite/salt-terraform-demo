provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "opensuse_leap" {

    name = "opensuse_leap"
    source = "http://download.opensuse.org/repositories/Cloud:/Images:/Leap_42.1/images/openSUSE-Leap-42.1-OpenStack.x86_64.qcow2"

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
    count = 1
}

resource "libvirt_domain" "saltminion" {

    name = "dsaltminion-${count.index}"
    disk {
        volume_id = "${element(libvirt_volume.minionvolume.*.id, count.index)}"
    }
    count = 2
}
