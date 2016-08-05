..
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _installation:

Installation
===============================================================================

All required tools are available on the `OSGeo Live <http://live.osgeo.org>`_.


This chapter covers how to use `OSGeo Live` on your computer.

* :ref:`install_osgeo_usb`
* :ref:`install_osgeo_vm`

The following reference is a quick summary of how to use OSGeo Live on your computer.

.. important:: Before attending a workshop event, make sure your you can use `OSGeo Live` with either method or :ref:`Install pgRouting <more_installation>`.  

.. _install_osgeo_usb:

OSGeo Live using a USB stick or CD
---------------------------------------

 
Follow the instructions on `OSGeo Live <http://live.osgeo.org>`_ to prepare your USB stick or CD
 
* Insert the USB or CD
* Restart your computer and wait for that first screen to pop up. Often, it'll say something like

  "Press F12 to Choose Boot Device" somewhere on the screen.  Press that key now."

* Give it a moment to continue booting, and you should see a menu pop up with a list of choices on it.

  * Highlight your CD or USB drive and press Enter.

* Exit the menu, the computer will restart using the selected device
* Choose your preferred language and click on ‘Try Ubuntu’.

More information on: http://www.ubuntu.com/download/desktop/try-ubuntu-before-you-install


.. _install_osgeo_vm:

OSGeo Live on a virtualBox
---------------------------------------

* You need `virtualBox <https://www.virtualbox.org/>`_ software
* Go to https://sourceforge.net/projects/osgeo-live/files/10.0/ and download `osgeo-live-10.0-amd64.iso`
* Open virtualBox and click **new**
* Fill name and operating system

    .. thumbnail:: images/firstScreen.png

* Fill memory size

    .. thumbnail:: images/firstScreen2.png

* Fill hard drive

    .. thumbnail:: images/firstScreen3.png

* Fill hard drive file type

    .. thumbnail:: images/firstScreen4.png

* Fill Storage on physical hard drive

    .. thumbnail:: images/firstScreen5.png

* Fill Storage on physical hard drive

    .. thumbnail:: images/firstScreen6.png

* Fill File location and size

    .. thumbnail:: images/firstScreen7.png

* Click on storage & click on "add icon" and "add CD/DVD device"

    .. thumbnail:: images/firstScreen8.png

* Add the `osgeo-live-10.0-amd64.iso` file.

    .. thumbnail:: images/firstScreen9.png

* Now you have OSGeo Live on the virtualBox

    .. thumbnail:: images/firstScreen10.png

* Double Click on "OSGeo live 10".
* Choose your preferred language and click on ‘Try Ubuntu’.
* to be able to use the Clipboard between your computer and the virtual machine:

  * :menuselection:`devices --> Shared Clipboard --> bidirectional`


