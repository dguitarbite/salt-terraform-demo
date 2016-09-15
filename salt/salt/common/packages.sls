common_packages:
  pkg.installed:
    - pkgs:
      - htop
      - strace
      - vim

vim installed:
  pkg.installed:
    - name: {{ pillar['editor'] }}
