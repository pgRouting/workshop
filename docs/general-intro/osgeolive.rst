..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

OSGeoLive Installation
===============================================================================

All required tools are available on `OSGeoLive <http://live.osgeo.org>`__.

* `OSGeoLive Quickstart for Running in a Virtual Machine
  <https://live.osgeo.org/en/quickstart/virtualization_quickstart.html>`__
* `Creating an OSGeoLive Bootable USB flash drive
  <https://live.osgeo.org/en/quickstart/usb_quickstart.html>`__

.. important:: Before attending a workshop event, make sure your you can use
  `OSGeoLive` with either method or
  :doc:`../appendix/appendix-2` on your computer.

This workshop uses OSGeoLive on VirtualBox.

.. contents:: Chapter Contents

Install `VirtualBox <https://www.virtualbox.org/>`__.
-------------------------------------------------------------------------------

This is a general description on how to install VirtualBox.
Complete details about installation can be found on the `VirtualBox
<https://www.virtualbox.org/>`__ documentation.

.. rubric:: Linux distributions:

Add the following line to your /etc/apt/sources.list.
According to your distribution, replace `<mydist>` with your distribution name.

::

  deb https://download.virtualbox.org/virtualbox/debian <mydist> contrib

Add the keys:

::

  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

Install Virtual box using:

::

  sudo apt-get update
  sudo apt-get install virtualbox-6.1

More detailed and up to date information can be found `here
<https://www.virtualbox.org/wiki/Linux_Downloads>`__

OSGeoLive on a VirtualBox
-------------------------------------------------------------------------------

Download OSGeoLive @OSGeoLive_VERSION@
...............................................................................

This installation method corresponds for the ``iso`` distribution of OSGeoLive.
For other installations visit `OSgeoLive
<https://osgeo.github.io/OSGeoLive-doc/en/index.html>`__

.. note::
   The images on this section might not correspond to the VirtualBox or
   OSGeoLive version installed on your system, but the workflow is similar.

From https://download.osgeo.org/livedvd/releases/@OSGeoLive_VERSION@/

* Download *osgeolive-@OSGeoLive_VERSION@-amd64.iso*

.. image:: /images/osgeolive/get_osgeolive_latest.png

Download is saved on Downloads directory.

.. image:: /images/osgeolive/downloadOSGeoLive.png

Create the virtual machine
...............................................................................

Open the Virtual Box

.. image:: /images/osgeolive/install-vm.png

Click on ``New`` and fill with the following information

* **Name** OSGeoLive @OSGeoLive_VERSION@
* **Type** Linux
* **Version** Ubuntu (64-bit)
* **Memory size** 4096
* **Hard disk** Create a virtual hard disk now

.. image:: /images/osgeolive/createVirtualMachine.png

Click on ``Create`` and fill with the following information

* **File location** Choose a suitable location for the Virtual Hard Disk
* **File size** 10.0GB
* **Hard disk file type** VDI (VirtualBox Disk image)
* **Storage on physical hard disk** Dynamically allocated

.. image:: /images/osgeolive/createVirtualHardDisk.png

Install OSGeoLive's ISO
...............................................................................

On Storage it reads:

:Controller: IDE
:IDE Secondary Device 0: [Optical Drive] empty

.. image:: /images/osgeolive/afterCreateVM.png

Choose ``Storage`` from the virtual box traits and clink on ``Empty``

.. image:: /images/osgeolive/storageWithEmpty.png

Click on the small disk icon and select **Choose/Create a Virtual Disk**

.. image:: /images/osgeolive/chooseVirtualDisk.png

Navigate to the location where the ISO was installed

.. image:: /images/osgeolive/chooseOSGeoLiveISO.png

Instead of empty, now it has the ISO installed

.. image:: /images/osgeolive/withISOinstalled.png

The installation now reads:

:Controller: IDE
:IDE Secondary Device 0: [Optical Drive] osgeolive-10.0alpha3-amd64.iso (4.13
                         GB)

.. image:: /images/osgeolive/previewOsgeoLive.png

Start OSGeoLive
...............................................................................

Click on ``Start`` button, and click on ``capture``, to capture the mouse
movements

.. image:: /images/osgeolive/captureMouse.png

Click on ``Try or Install Lubuntu``

.. image:: /images/osgeolive/chooseTryLubuntu.png

.. note:: OSGeoLive's account is ``user`` and password is ``user``

After a few seconds OSGeoLive will start

.. image:: /images/osgeolive/osgeoliveStarts.png


.. Note:: OSGeoLive’s account is ``user`` and password is ``user``




Ubuntu installation
-------------------------------------------------------------------------------

Update sources to include postgresql ::

  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ \
      $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

Install PostgrSQL, PostGIS and pgRouting ::

  sudo apt-get update
  sudo apt-get install -y \
    osm2pgrouting \
    postgresql-15 \
    postgresql-15-postgis-3 \
    postgresql-15-postgis-3-scripts \
    postgresql-15-pgrouting
