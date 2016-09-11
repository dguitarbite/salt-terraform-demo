{% from "simplerpc/map.jinja" import simplerpc with context %}

simplerpc:
  pkg:
    - installed
    - name: {{ simplerpc.pkg }}
  service:
    - running
    - name: {{ simplerpc.service }}
    - enable: True
    - require:
      - pkg: simplerpc
