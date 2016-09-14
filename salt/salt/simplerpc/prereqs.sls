pika_installed:
  pkg.installed:
    - name: python-pika

Clone simplerpc repo:
  pkg.installed:
    - name: git
  git.latest:
    - name: https://github.com/dguitarbite/salt-terraform-demo.git
    - rev: master
    - target: /srv/simplerpc/
