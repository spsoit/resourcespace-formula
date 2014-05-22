{% from 'resourcespace/map.jinja' import resourcespace, sls_block with context %}

include:
  - resourcespace
  - {{ resourcespace.php.states.fpm }}

extend:
  php_fpm_service:
    service:
      - watch:
        - file: resourcespace_config
        - archive: resourcespace_install
      - require:
        - file: resourcespace_config
        - file: resourcespace_storage
