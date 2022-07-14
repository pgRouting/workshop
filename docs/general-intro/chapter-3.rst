..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************



Installation
===============================================================================

All required tools are available on `OSGeoLive <http://live.osgeo.org>`__.

* `OSGeoLive Quickstart for Running in a Virtual Machine
  <https://live.osgeo.org/en/quickstart/virtualization_quickstart.html>`__
* `Creating an OSGeoLive Bootable USB flash drive
  <https://live.osgeo.org/en/quickstart/usb_quickstart.html>`__

.. important:: Before attending a workshop event, make sure your you can use
  `OSGeoLive` with either method or
  :doc:`../appendix/appendix-2` on your computer.

This workshop uses OSGeoLive on VirtualBox

* :ref:`install_osgeo_vm`

.. contents:: Chapter Contents

.. _install_osgeo_vm:

OSGeoLive on a VirtualBox
-------------------------------------------------------------------------------

Install `VirtualBox <https://www.virtualbox.org/>`__.
...............................................................................

Complete details about installation can be found on the
`VirtualBox <https://www.virtualbox.org/>`__ documentation.



.. rubric:: Linux distributions:

Add the following line to your /etc/apt/sources.list.
According to your distribution, replace '<mydist>' with your distribution name.

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


Download OSGeoLive 15.0
...............................................................................

This installation corresponds for the ``iso`` distribution of OSGeoLive.
For other installations visit `OSgeoLive <https://live.osgeo.org/en/index.html>`__

.. note::
   The images on this section might not correspond to the VirtualBox
   version installed on your system. The workflow is similar.

* download *osgeolive-15.0-amd64.iso*

  From https://sourceforge.net/projects/osgeo-live/files/15.0/

  .. image:: images/chapter3/downloadOSGeoLive.png
       :width: 150px

* Open VirtualBox and click :menuselection:`New`

  .. image:: images/chapter3/install-vm.png
       :width: 150px

* Fill required info

  :name: osgeolive 15
  :Machine Folder: choose the appropriate location
  :Type: choose the appropriate operating system
  :Version: choose the 64 bit appropiate version

  .. image:: images/chapter3/install-1.png
      :width: 150px

* Create a dynamically allocated storage hard disk

  .. image:: images/chapter3/install-2.png
      :width: 150px

* Choose storage from the virtual box traits

  .. image:: images/chapter3/install-3.png
      :width: 150px

* Choose the empty disk and click on the Optical drive

  Select the `iso` file

  .. image:: images/chapter3/install-4.png
      :width: 150px

.. TODO update image to show the correct iso name

* The virtual drive should look like this

  .. image:: images/chapter3/install-5.png
      :width: 150px

.. note:: OSGeoLive's account is ``user`` and password is ``user``
