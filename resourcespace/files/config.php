{%- macro php_block(key, value) %}
    {%- if value is string: -%}
        ${{key}}='{{value|replace("'","\'")}}';
    {%- else -%}
        ${{key}}={{value}};
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
{% php_block(key, value) %}
{% endfor %}
