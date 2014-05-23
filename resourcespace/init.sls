# Installs the resourcespace application from source
{% from 'resourcespace/map.jinja' import resourcespace, sls_block with context %}

{% set lockdir_cfg = resourcespace.app.lockdown.opts %}
{% if resourcespace.app.lockdown.enabled %}
{% do lockdir.cfg.update {
    'user': resourcespace.app.lockdown.user,
    'group': resourcespace.app.lockdown.user,
} %}
{% else %}

{% endif %}

{% macro pkgs_list(pkgs) %}
      {% for pkg in pkgs %}
      - {{ resourcespace.lookup.pkgs.get(pkg) }}
      {% endfor %}
{% endmacro %}

include:
  - {{ resourcespace.php.states.php }}
  - {{ resourcespace.php.states.mcrypt }}
  - {{ resourcespace.php.states.imagick }}
  - {{ resourcespace.php.states.mysql }}
  - {{ resourcespace.php.states.gd }}
  - {{ resourcespace.php.states.apc }}
  - {{ resourcespace.php.states.curl }}

{% if resourcespace.pkg.installed|length() > 0 %}
resourcespace_optional_pkgs:
  pkg.installed:
    {{ sls_block(resourcespace.pkg.opts) }}
    - pkgs:
      {{ pkgs_list(resourcespace.pkg.installed) }}
    - require:
      - file: resourcespace_install
{% endif %}

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
