..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Installation
===============================================================================

All required tools are available on `OSGeo Live <http://live.osgeo.org>`_.

The following sections give a quick summary of how to setup OSGeo Live on your
computer.

* :ref:`install_osgeo_usb`
* :ref:`install_osgeo_vm`

.. important:: Before attending a workshop event, make sure your you can use
  `OSGeo Live` with either method or
  :ref:`Install pgRouting <more_installation>` on your computer.

.. _install_osgeo_usb:

OSGeo Live using a USB stick or DVD
-------------------------------------------------------------------------------

Follow the instructions on `OSGeo Live <http://live.osgeo.org>`_ to prepare
your USB stick or bootable DVD.

* Insert the USB or DVD
* Restart your computer and wait for that first screen to pop up. Often, it will
  say something like :command:`Press F12 to Choose Boot Device somewhere on the
  screen. Press that key now.`
* Give it a moment to continue booting, and you should see a menu pop up with a
  list of choices on it. There highlight select DVD or USB drive and confirm
  with :kbd:`Enter`.
* Exit the menu, the computer will restart using the selected device.
* Choose your preferred language and select :menuselection:`Try Ubuntu`.

More information on:
http://www.ubuntu.com/download/desktop/try-ubuntu-before-you-install

.. _install_osgeo_vm:

OSGeo Live on a virtualBox
-------------------------------------------------------------------------------

* First you need to install `VirtualBox <https://www.virtualbox.org/>`_.
* Go to https://sourceforge.net/projects/osgeo-live/files/11.0/ and download
  *osgeo-live-11.0-amd64.iso*
* Open VirtualBox and click :menuselection:`New`
* Fill *name* and *operating system*

  .. image:: /images/firstScreen.png
      :width: 150px
      :align: center

* Fill *memory size*

  .. image:: /images/firstScreen2.png
      :width: 150px
      :align: center

* Fill *hard drive*

  .. image:: /images/firstScreen3.png
      :width: 150px
      :align: center

* Fill *hard drive file type*

  .. image:: /images/firstScreen4.png
      :width: 150px
      :align: center

* Fill *Storage on physical hard drive*

  .. image:: /images/firstScreen5.png
      :width: 150px
      :align: center

* Fill *File location and size*

  .. image:: /images/firstScreen6.png
      :width: 150px
      :align: center

* Click on :menuselection:`Storage --> Add Icon --> Add CD/DVD device`

  .. image:: /images/firstScreen7.png
      :width: 150px
      :align: center

* Confirm with :menuselection:`Choose disk`

  .. image:: /images/firstScreen8.png
      :width: 150px
      :align: center

* Add the *osgeo-live-10.0-amd64.iso* file

  .. image:: /images/firstScreen9.png
      :width: 150px
      :align: center

* Now you have OSGeo Live configured to be used with VirtualBox

  .. image:: /images/firstScreen10.png
      :width: 150px
      :align: center

* Double-click on *OSGeo Live 11*.
* Choose your preferred language and click on *Try Ubuntu*.
* Select :menuselection:`Devices --> Shared Clipboard --> bidirectional` to be
  able to use the clipboard between your computer and the virtual machine.
