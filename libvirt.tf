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
    domain = "tfsaltdemo"
    addresses = ["10.5.4.0/29"]
}

resource "libvirt_volume" "mastervolume" {

    name = "dsaltmastervol"
    base_volume_id = "${libvirt_volume.opensuse_leap.id}"
}

resource "libvirt_volume" "minionvolume" {

    name = "dsaltminionvol-${count.index+1}"
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
        wait_for_lease = 1
    }
    cloudinit = "${libvirt_cloudinit.commoninit.id}"
    count = 1
    provisioner "remote-exec" {
         connection {
            user = "root"
            private_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAsMbQZa8IhkTfS1LG5FWHA2odkPgXbgVkB+f468qjkcngSMuI
mFqp8yKXPm8/nza9Le477/3+AdHOE0+uW4Mn6Mo8upA4TEPSuCZ0di3ih98LRNn3
/fuBcsHjjcq8QfxkMmOdcxgV/qhHcona7dyOHR4dJYm23pKJJg2/sUU1nSwAYvbV
z+5zHwZtPDC9kv/lHAsmarUqA5VZl1OpSKX/QolgEBD8phBOZwdIaZTL8ws9Iws4
AQbtcIBHz3jDI4BxkbVK+hEsySJtcyUz6Z93rx2rN9IiMalFtzpqhmmlitUCAX5z
/n8PkPGCz7tuDJNgrNpQ2X2t8VF0lQh8yd+GIQIDAQABAoIBAA2q4XPrK4KOEqGV
PdFrl2u5KZ4KwGz+N7Swx7sbSLg93nxiWCZHZDprIzxth4K8zbWeZL3yalAjs4Yk
s/tZUZ2a/UUDX4bt+33HY1u7wnb01L83Bwh5CJIh0YEl+pYzeF+4+fRrGVA+HIAL
joSzd71ilahQVHYy6C2sBHUlP7buDhWMlSDxrZ+kHSFq60e/1FcRenl8tqVJPTpT
tzqbNOKfMbUBK64o3FB2LR+UJObku4tUSVXP4pF6qJmnbRgjNLtOxOjc4o9Zsmke
ZsNyGZhdCE6q2Ing6gopfscgRlSo+XLUy95tiVbJ037tOjJfvuhXDyjfbREPPNaX
/JcbqpECgYEA2llNxL0uabEwSJ/jXEQAvA/36iO/DTZvM6rnPPWxpYvQDZBiS04O
QHllvrsjhk2lOCM1OCpW0/E3HCJIGw0wdVdxiFta38uxL++DYA6lP5SMVuKJeBao
SqBg6UMpGjhLnznASXBFQQ4eCajUMR9xN6sEHp1/tACZq/oPRTUWi4UCgYEAz0Jd
MosbDPMUMmBhJl1w1SI2n+kHljVIYHN5bhN5wb/QZQfZGPMjBaBOWPBpd5yGYfVi
39pDjpdSxBauRPur8ZeBPFkz7hiPaiKjMpf9pxRSWAlXDZljtPWhBfSI3r05zoFN
KVTpiZTNzOGMl/A33u+mbT+mkxn61TGxQ1knrO0CgYAJW9SKfzVTEGYqZrf/B2ck
qGaO4ZNZxKCFjWi14y4HE3QKcMrVwXW467shrrG6Gu/e9Rtd2eq40Nj02r9OcYVH
MkVKe+fsObXRgSmXX2lTzVEqlDEiNY5nDHK67McBObJ8E6SbQTWmsS02ascVh+x5
X1og2c1UcMYlaeVnqPvbZQKBgAZp21BxFYk1DG7ypI73XUJ7KI2SPHXdeDvj1uId
ICtqsBwwPfuTqoXGDCacaecVpOLrIQAkVOrYq+r9eK8RyqRTN+CSMhUwFWAHal1q
bqL48gNfZp45HOjAoRb6FjIuUNefELAyvHdRb3zjjeI1wMTZTaEb0x/CMgze2Mlo
vN2RAoGBAJIVscXEHWDE59ZXbgeTULMZUeoJYRxkWQMBOEEB6cxmgzHy5kb+aYl4
GKeG8GcpvC0Ujaf5yRAhxobz4LIU6qWzVyZQwKZ5V8edAnzZGXhDzODivNvANPFg
hYf7AGKNE/1Vzai+7iaZkDppVVWJczKi/AjQkRQXUyLmDovd+KaO
-----END RSA PRIVATE KEY-----"
        }       inline = [
            "echo 'Hello' > /root/hello",
            "echo 'Hi'",
            "echo 'saltmaster.tfsaltdemo' > /etc/hostname"
        ]
    }
}

resource "libvirt_domain" "saltminion" {

    name = "dsaltminion-${count.index+1}"
    disk {
        volume_id = "${element(libvirt_volume.minionvolume.*.id, count.index+1)}"
    }
    network_interface {
        network_id = "${libvirt_network.tfsaltdemo.id}"
        hostname = "saltminion${count.index+1}"
        wait_for_lease = 1
    }
    cloudinit = "${libvirt_cloudinit.commoninit.id}"
    count = 2

    provisioner "remote-exec" {
        connection {
            user = "root"
            private_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAsMbQZa8IhkTfS1LG5FWHA2odkPgXbgVkB+f468qjkcngSMuI
mFqp8yKXPm8/nza9Le477/3+AdHOE0+uW4Mn6Mo8upA4TEPSuCZ0di3ih98LRNn3
/fuBcsHjjcq8QfxkMmOdcxgV/qhHcona7dyOHR4dJYm23pKJJg2/sUU1nSwAYvbV
z+5zHwZtPDC9kv/lHAsmarUqA5VZl1OpSKX/QolgEBD8phBOZwdIaZTL8ws9Iws4
AQbtcIBHz3jDI4BxkbVK+hEsySJtcyUz6Z93rx2rN9IiMalFtzpqhmmlitUCAX5z
/n8PkPGCz7tuDJNgrNpQ2X2t8VF0lQh8yd+GIQIDAQABAoIBAA2q4XPrK4KOEqGV
PdFrl2u5KZ4KwGz+N7Swx7sbSLg93nxiWCZHZDprIzxth4K8zbWeZL3yalAjs4Yk
s/tZUZ2a/UUDX4bt+33HY1u7wnb01L83Bwh5CJIh0YEl+pYzeF+4+fRrGVA+HIAL
joSzd71ilahQVHYy6C2sBHUlP7buDhWMlSDxrZ+kHSFq60e/1FcRenl8tqVJPTpT
tzqbNOKfMbUBK64o3FB2LR+UJObku4tUSVXP4pF6qJmnbRgjNLtOxOjc4o9Zsmke
ZsNyGZhdCE6q2Ing6gopfscgRlSo+XLUy95tiVbJ037tOjJfvuhXDyjfbREPPNaX
/JcbqpECgYEA2llNxL0uabEwSJ/jXEQAvA/36iO/DTZvM6rnPPWxpYvQDZBiS04O
QHllvrsjhk2lOCM1OCpW0/E3HCJIGw0wdVdxiFta38uxL++DYA6lP5SMVuKJeBao
SqBg6UMpGjhLnznASXBFQQ4eCajUMR9xN6sEHp1/tACZq/oPRTUWi4UCgYEAz0Jd
MosbDPMUMmBhJl1w1SI2n+kHljVIYHN5bhN5wb/QZQfZGPMjBaBOWPBpd5yGYfVi
39pDjpdSxBauRPur8ZeBPFkz7hiPaiKjMpf9pxRSWAlXDZljtPWhBfSI3r05zoFN
KVTpiZTNzOGMl/A33u+mbT+mkxn61TGxQ1knrO0CgYAJW9SKfzVTEGYqZrf/B2ck
qGaO4ZNZxKCFjWi14y4HE3QKcMrVwXW467shrrG6Gu/e9Rtd2eq40Nj02r9OcYVH
MkVKe+fsObXRgSmXX2lTzVEqlDEiNY5nDHK67McBObJ8E6SbQTWmsS02ascVh+x5
X1og2c1UcMYlaeVnqPvbZQKBgAZp21BxFYk1DG7ypI73XUJ7KI2SPHXdeDvj1uId
ICtqsBwwPfuTqoXGDCacaecVpOLrIQAkVOrYq+r9eK8RyqRTN+CSMhUwFWAHal1q
bqL48gNfZp45HOjAoRb6FjIuUNefELAyvHdRb3zjjeI1wMTZTaEb0x/CMgze2Mlo
vN2RAoGBAJIVscXEHWDE59ZXbgeTULMZUeoJYRxkWQMBOEEB6cxmgzHy5kb+aYl4
GKeG8GcpvC0Ujaf5yRAhxobz4LIU6qWzVyZQwKZ5V8edAnzZGXhDzODivNvANPFg
hYf7AGKNE/1Vzai+7iaZkDppVVWJczKi/AjQkRQXUyLmDovd+KaO
-----END RSA PRIVATE KEY-----"
        }
        inline = [
            "echo 'Hello' > /root/hello",
            "echo 'Hi'",
            "echo saltminion${count.index+1} > /etc/hostname"
        ]
    }
}

output "masterip" {

    value = "${libvirt_domain.saltmaster.host}"
}

output "minionsip" {

    value = ["${libvirt_domain.saltminion.*.host}"]
}
