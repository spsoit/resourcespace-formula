# Installs the resourcespace application from source
{% from 'resourcespace/map.jinja' import resourcespace, sls_block with context %}

include:
  - php
  - php.imagick
  - php.mysql
  - php.gd
  - php.apc
  - php.curl

resourcespace_install:
  file.directory:
    {{ sls_block(resourcespace.app.app_root) }}
    - name: {{ resourcespace.app.shared.webroot }}
  archive.extracted:
    {{ sls_block(resourcespace.app.source) }}
    - name: {{ resourcespace.app.shared.webroot }}
    - if_missing: {{ resourcespace.app.source.get('if_missing', resourcespace.app.shared.webroot ~  resourcespace.app.shared.index) }}
    - require:
      - file: resourcespace_install

resourcespace_config:
  file.managed:
    - name: {{ resourcespace.app.shared.webroot ~ resourcespace.app.shared.config }}
    - template: jinja
    - source: salt://resourcespace/files/config.php
    - context:
      config: {{ resourcespace.app.config }}
    - require:
      - archive: resourcespace_install

resourcespace_storage:
  file.directory:
    {{ sls_block(resourcespace.storage.directory) }}
    - name: {{ resourcespace.app.shared.filestore }}
    - user: {{ resourcespace.lookup.webuser }}
    - group: {{ resourcespace.lookup.webgroup }}
    - require:
      - archive: resourcespace_install

  {% if resourcespace.storage.mount %}
  mount.mounted:
    {{ sls_block(resourcespace.storage.mount) }}
    require_in:
      - file: resourcespace_storage
  {% endif %}
