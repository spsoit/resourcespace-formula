# installs the resourcespace application from source
{% from 'resourcespace/map.jinja' import resourcespace with context %}
{% set test_file = resourcespace.app.app_root ~ resourcespace.app.test_success %}
{% set conf_file = resourcespace.app.app_root ~ resourcespace.app.conf_file %}


include:
  - php
  - php.imagick
  - php.mysql
  - php.gd
  - php.apc
  - php.curl

resourcespace_install:
  file.directory:
    - name: {{ resourcespace.app.app_root }}
    - makedirs: True
  archive.extracted:
    - name: {{ resourcespace.app.app_root }}
    - source: {{ resourcespace.app.source }}
    - source_hash: {{ resourcespace.app.checksum }}
    - archive_format: zip
    - if_missing: {{ test_file }}
    - require:
      - archive: resourcespace_install

resourcespace_config:
  file.managed:
    - name: {{ conf_file }}
    - template: jinja
    - source: salt://resourcespace/files/config.php
    - context:
      config: {{ resourcespace.app.config }}
    - require:
      - archive: resoucespace_install
