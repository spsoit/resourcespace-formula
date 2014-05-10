# installs the resourcespace application from source
{% from 'resourcespace/map.jinja' import resourcespace with context %}
{% set test_file = resourcespace.app.app_root ~ resourcespace.app.test_success %}
{% set conf_file = resourcespace.app.app_root ~ resourcespace.app.conf_file %}


import:
  - php
  - php.imagick
  - php.mysql
  - php.gd
  - php.apc
  - php.curl

resourcespace-install:
  archive.extracted:
    - name: {{ resourcespace.app.app_root }}
    - source: {{ resourcespace.app.source }}
    - source_hash: {{ resourcespace.app.checksum }}
    - archive_format: zip
    - if_missing: {{ test_file }}
  file.managed:
    - name: {{ conf_file }}
    - template: jinja
    - source: salt://resourcespace/files/config.php
    - context:
      config: {{ resourcespace.app.config }}
  
