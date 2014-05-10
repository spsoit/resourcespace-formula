===
ntp
===

Formulas to set up and configure Resourcespace.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``resourcespace``
-----------------

Installs the resourcespace application from a third-party source.

This state requires the PHP_ Salt Formula.

.. _PHP: https://github.com/saltstack-formulas/php-formula

``resourcespace.nginx``
-----------------------

Installs the Nginx web server and configures a virtual host to work with
Resourcespace. This state requires the Nginx_ Salt Formula.

.. _:Nginx https://github.com/saltstack-formulas/nginx-formula

``resourcespace.php_fpm``
-------------------------

Installs the PHP-FPM service and configures it for Resourcespace.

This state requires the PHP_ Salt Formula.

.. _PHP: https://github.com/saltstack-formulas/php-formula


