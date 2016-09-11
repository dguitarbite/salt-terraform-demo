{% from "simplerpc/map.jinja" import simplerpc, simplerpc_config with context %}

include:
  - simplerpc

simplerpc-config:
  file.managed:
    - name: {{ simplerpc.conf_file }}
    - source: salt://simplerpc/templates/conf.jinja
    - template: jinja
    - context:
      config: {{ simplerpc_config }}
    - watch_in:
      - service: simplerpc
    - require:
      - pkg: simplerpc
