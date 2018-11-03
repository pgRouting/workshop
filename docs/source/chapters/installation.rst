..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Installation
===============================================================================

All required tools are available on `OSGeo Live <http://live.osgeo.org>`__.

* `OSGeoLive Quickstart for Running in a Virtual Machine <https://live.osgeo.org/en/quickstart/virtualization_quickstart.html>`__
* `Creating an OSGeoLive Bootable USB flash drive <https://live.osgeo.org/en/quickstart/usb_quickstart.html>`__

.. important:: Before attending a workshop event, make sure your you can use
  `OSGeo Live` with either method or
  :ref:`Install pgRouting <more_installation>` on your computer.

This workshop uses OSGeoLive on virtuabBox

* :ref:`install_osgeo_vm`


.. _install_osgeo_vm:

OSGeo Live on a virtualBox
-------------------------------------------------------------------------------

Install `VirtualBox <https://www.virtualbox.org/>`__.
...............................................................................

.. rubric:: Linux distributions:

Add the following line to your /etc/apt/sources.list.
According to your distribution, replace '<mydist>' with 'artful', 'zesty', 'yakkety', 'xenial', 'trusty', 'stretch', 'jessie', or 'wheezy'

::

  deb https://download.virtualbox.org/virtualbox/debian <mydist> contrib

Add the keys:

::

  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -


Download OSGeoLive 12.0
...............................................................................

* Go to https://sourceforge.net/projects/osgeo-live/files/12.0/ and download
  *osgeolive-12.0-vm.7z*

  .. image:: /images/downloadOSGeoLive.png
       :width: 150px


* Open VirtualBox and click :menuselection:`New`

  .. image:: /images/install-vm.png
       :width: 150px

* Fill *name* and *operating system*

  .. image:: /images/install-name.png
      :width: 150px

* Fill *memory size*

  .. image:: /images/install-memory.png
      :width: 150px

* Fill *hard disk* & create

  .. image:: /images/install-disk.png
      :width: 150px

* Fill *General* & Choose *bidirectional* (to be able o use the clipboard between your computer and the virtual machine.)

  .. image:: /images/install-general.png
      :width: 150px

* Double-click on *OSGeoLive12* & Read *Welcome message*

  .. image:: /images/install-welcome.png
      :width: 150px

* Ready to use

  .. image:: /images/install-final.png
      :width: 150px

.. note:: OSGeo Live's account is ``user`` and password is ``user``
