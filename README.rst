=====
pgTap
=====

A Docker image for running `pgTap`_ tests against a PostgreSQL database.

Inspired by and based on https://gitlab.com/ringingmountain/docker/pgtap

Usage
-----

.. code-block:: bash

   docker run --rm -e PGPASSWORD=secret -v $tests_dir:/t \
     disaykin/pgtap:latest [-h DBHOST] [-p DBPORT] [-U DBUSER] [-d DBNAME] -t /t/*.sql


.. _pgTap: https://pgtap.org/
