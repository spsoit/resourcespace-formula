{% from 'resourcespace/map.jinja' import resourcespace, sls_block with context %}

include:
  - resourcespace
  - {{ resourcespace.nginx.state }}

extend:
  nginx_service:
    service:
      - require:
        - file: resourcespace_config
        - file: resourcespace_storage
