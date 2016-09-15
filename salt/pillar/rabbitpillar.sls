rabbitmq:
  enabled: True
  running: True
  vhost:
    vh_name: '/virtual/host'
  user:
    simplerpc:
      - password: simplerpc
      - force: True
      - tags: monitoring, user
      - perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
      - runas: root
