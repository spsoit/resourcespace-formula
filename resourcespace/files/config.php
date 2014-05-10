{%- macro quote_val(value) %}
{% if value is number -%}
  {{ value }}
{%- else -%}
  '{{ value|replace("'", "\'"}}'
{%- endif %}
{% endmacro -%}

{%- macro php_block(key, value, operator='=', delim=';', keypre = '$', ind=0) %}
    {%- if value is iterable: -%}
        {{ keypre|indent(ind) }}{{ key }} {{ operator }} array(
        {%- for k, v in value.items() %}
            {{ php_block(k, v, '=>', ',', '', (ind + 4) }}
        {% endfor -%}
        {{ ')'|indent(ind) }}{{delim}}
    {%- else -%}
        {{ keypre|indent(ind) }}{{ quote_val(key) }} {{ operator }} {{ value }}{{ delim }}
    {%- endif -%}
{% endmacro -%}
<?php
/**
 * This file contains the default configuration settings.
 * 
 * **** DO NOT ALTER THIS FILE! ****
 *
 * This file is managed by Salt.
 *
 * @package ResourceSpace
 * @subpackage Configuration
 * 
 */

{% for key,value in config.items() %}
{{ php_block(key, value) }}
{% endfor %}
