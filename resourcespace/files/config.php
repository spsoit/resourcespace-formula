{% set indent_increment = 4 %}

{%- macro php_escape(value) -%}
    {%- if value is number -%}
        {{ value }}
    {%- else -%}
        '{{ value|replace("'", "\'") }}'
    {%- endif -%}
{%- endmacro -%}

{%- macro php_block(value, key=None, operator=' = ', delim=';', keypre='$', ind=0) -%}
    {%- if value is number or value is string -%}
        {{ keypre|indent(ind, True) }}{{ key }}{{ operator }}{{ php_escape(value) }}{{ delim }}
    {%- elif value is mapping -%}
        {{ keypre|indent(ind, True) }}{{ key }}{{ operator }}array(
        {%- for k, v in value.items() %}
{{ php_block(v, php_escape(k), ' => ', ',', '', (ind + indent_increment)) }}
        {%- endfor %}
{{ ')'|indent(ind, True) }}{{ delim }}
    {%- elif value is iterable -%}
        {{ keypre|indent(ind, True) }}{{ key }}{{ operator }}array(
        {%- for v in value %}
{{ php_block(v, '', '', ',', '', (ind + indent_increment)) }}
        {%- endfor %}
{{ ')'|indent(ind, True) }}{{ delim }}
    {%- else -%}
        {{ keypre|indent(ind, True) }}{{ php_escape(key) }}{{ operator }}{{ php_escape(value) }}{{ delim }}
    {%- endif -%}
{%- endmacro -%}
<?php
/**
 * This file contains custom configuration settings.
 * 
 * **** DO NOT ALTER THIS FILE! ****
 *
 * This file is managed by Salt.
 *
 * @package ResourceSpace
 * @subpackage Configuration
 * 
 */

{% for key, value in config.items() %}
{{ php_block(value, key) }}
{%- endfor -%}
