OpenAFS Robotest
================

OpenAFS Robotest is a set of `Robot Framework`_ test cases for the OpenAFS_
distributed filesystem.  The test cases cover basic usage on a single client
and general OpenAFS administration.

An Ansible Molecule template with Ansible playbooks is provided to quickly
deploy a Kerberos test realm and OpenAFS test cell on virtual machines, install
Robot Framework, and execute the tests.

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   guide
   running
   tests
   tags
   vars
   libs
   devel
   license

.. _`Robot Framework`: https://robotframework.org/
.. _OpenAFS: https://www.openafs.org
