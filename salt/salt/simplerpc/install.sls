Install Server Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/server.py -O /usr/local/lib/simplerpc-server
    - unless: ls /usr/local/lib/ | grep simplerpc-server

Install Client Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/client.py -O /usr/local/lib/simplerpc-client
    - unless: ls /usr/local/lib/ | grep simplerpc-client

Install BasicMath Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/basicmath.py -O /usr/local/lib/basicmath.py
    - unless: ls /usr/local/lib/ | grep basicmath

Init.py not ideal:
  cmd.run:
    - name: touch /usr/local/lib/__init__.py
    - unless: ls /usr/local/lib/ | grep __init__

Exec them perms:
  cmd.run:
    - name: chmod -R 0111 /usr/local/lib/*.py
