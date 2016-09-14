common_packages:
  pkg.installed:
    - pkgs:
      - htop
      - strace
      - vim

vim installed:
  pkg.installed:
    - name: {{ pillar['editor'] }}

Add RMQ Repo:
  cmd.run:
    - name: zypper ar -f -G http://download.opensuse.org/repositories/Cloud:/OpenStack:/Mitaka/openSUSE_Leap_42.1/ RMQP
    - cwd: /

Refresh Zypp:
  cmd.run:
    - name: zypper ref
    - cwd: /
