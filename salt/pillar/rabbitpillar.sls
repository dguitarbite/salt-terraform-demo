rabbitmq:
  enabled: True
  running: True
  plugin:
    rabbitmq_management:
      - enabled
  policy:
    rabbitmq_policy:
      - name: HA
      - pattern: '.*'
      - definition: '{"ha-mode": "all"}'
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
