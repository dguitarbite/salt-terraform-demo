Install Server Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/server.py -O /usr/local/lib/simplerpc-server

Install Client Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/client.py -O /usr/local/lib/simplerpc-client

Install BasicMath Script:
  cmd.run:
    - name: wget https://raw.githubusercontent.com/dguitarbite/salt-terraform-demo/master/simplerpc/basicmath.py -O /usr/local/lib/basicmath.py

Init.py not ideal:
  cmd.run:
    - name: touch /usr/local/lib/__init__.py

Exec them perms:
  cmd.run:
    - name: chmod -R 0111 /usr/local/lib/*.py
