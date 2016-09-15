Add RMQ Repo:
  cmd.run:
    - name: zypper ar -f -G obs://Cloud:OpenStack:Mitaka RMQP
    - cwd: /
    - unless: zypper lr | grep RMQP

Refresh Zypp:
  cmd.run:
    - name: zypper ref
    - cwd: /

Install RMQ:
  pkg.installed:
    - pkgs:
      - rabbitmq-server
      - rabbitmq-server-plugins
    - fromrepo: RMQP
  service:
    - name: rabbitmq-server
    - running
    - enable: True

Create RMQ Users:
  cmd.run:
    - name: rabbitmqctl add_user simplerpc simplerpc
    - cwd: /
    - unless: rabbitmqctl list_users | grep simplerpc

Set RMQ Permissions:
  cmd.run:
    - name: rabbitmqctl set_permissions simplerpc '.*' '.*' '.*'
    - cwd: /
    - unless: rabbitmqctl list_permissions | grep simplerpc

Enable RMQ Plugins:
  cmd.run:
    - name: HOME=/root rabbitmq-plugins enable rabbitmq_management && systemctl restart rabbitmq-server.service
    - runas: root
    - unless: HOME=/root && rabbitmq-plugins list | grep 'E' | grep 'rabbitmq_management'
