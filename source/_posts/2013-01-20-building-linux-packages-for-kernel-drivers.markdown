---
author: admin
comments: true
date: 2013-01-20 03:39:48+00:00
layout: post
slug: building-linux-packages-for-kernel-drivers
title: Building Linux Packages For Kernel Drivers! (dkms howto)
wordpress_id: 835
categories:
tags:
- debs
- dkms
- kernel modules
- linux
- packages
---

# Background


Most of the time the Linux kernel does a great job of having drivers you need, but sometimes you need to install a special driver or update an existing module.

Running make; make install is all fine and dandy for testing, but for production you want a repeatable process. For me, this means OS packages. (deb/rpms)

[![33657094](/uploads/33657094-300x181.jpg)](https://xkyle.com/building-linux-packages-for-kernel-drivers/attachment/33657094/)



So, how do you go from kernel module source code => Debian package? DKMS. DKMS will automatically build your kernel module for you, even if your kernel gets updated.

Lets build something. In this example I'm on an Ubuntu machine building the latest ixgbe driver.

1. Get apt-get your stuff

    
    apt-get install debhelper dkms kernel-headers


2. Untar your source code into /usr/src/$modulename-$version, like /usr/src/ixgbe-3.12.6/
3. Normally here you would run "make", but instead we will make a dkms.conf file to describe how to build it. Like this:

    
    MAKE="make -C src/ KERNELDIR=/lib/modules/${kernelver}/build"
    CLEAN="make -C src/ clean"
    BUILT_MODULE_NAME=ixgbe
    BUILT_MODULE_LOCATION=src/
    DEST_MODULE_LOCATION="/updates"
    PACKAGE_NAME=ixgbe-dkms
    PACKAGE_VERSION=3.12.6
    REMAKE_INITRD=no


4. Next we need to register that module with dkms:

    
    root@server:/usr/src/ixgbe-3.12.6# dkms add -m ixgbe -v 3.12.6
    Creating symlink /var/lib/dkms/ixgbe/3.12.6/source ->
     /usr/src/ixgbe-3.12.6
    DKMS: add completed.


5. Next we will build the module, but using the dkms build command instead of make:

    
    root@server:/usr/src/ixgbe-3.12.6# dkms build -m ixgbe -v 3.12.6
    Kernel preparation unnecessary for this kernel. Skipping...
    Building module:
    cleaning build area....
    make KERNELRELEASE=3.2.0-23-generic -C src/ KERNELDIR=/lib/modules/3.2.0-23-generic/build....................
    cleaning build area....
    DKMS: build completed.


6. Great! Next we will make a debian src package.

    
    root@server:/usr/src/ixgbe-3.12.6# dkms mkdsc -m ixgbe -v 3.12.6 --source-only
    Using /etc/dkms/template-dkms-mkdsc
    copying template...
    modifying debian/changelog...
    modifying debian/compat...
    modifying debian/control...
    modifying debian/copyright...
    modifying debian/dirs...
    modifying debian/postinst...
    modifying debian/prerm...
    modifying debian/README.Debian...
    modifying debian/rules...
    copying legacy postinstall template...
    Copying source tree...
    Building source package... dpkg-source --before-build ixgbe-dkms-3.12.6
     debian/rules clean
     dpkg-source -b ixgbe-dkms-3.12.6
    dpkg-source: warning: no source format specified in debian/source/format, see dpkg-source(1)
     dpkg-genchanges -S >../ixgbe-dkms_3.12.6_source.changes
    dpkg-genchanges: including full source code in upload
     dpkg-source --after-build ixgbe-dkms-3.12.6
    DKMS: mkdsc completed.
    Moving built files to /var/lib/dkms/ixgbe/3.12.6/dsc...
    Cleaning up temporary files...


7. Now we will build the "binary" debian package. In reality with --source-only this binary package just contains the source code in the module with a post install script to build the module for each kernel you are using. Its magic:

    
    root@server:/usr/src/ixgbe-3.12.6# dkms mkdeb -m ixgbe -v 3.12.6 --source-only
    Using /etc/dkms/template-dkms-mkdeb
    copying template...
    modifying debian/changelog...
    modifying debian/compat...
    modifying debian/control...
    modifying debian/copyright...
    modifying debian/dirs...
    modifying debian/postinst...
    modifying debian/prerm...
    modifying debian/README.Debian...
    modifying debian/rules...
    copying legacy postinstall template...
    Copying source tree...
    Building binary package...dpkg-buildpackage: warning: using a gain-root-command while being root
     dpkg-source --before-build ixgbe-dkms-3.12.6
     fakeroot debian/rules clean
     debian/rules build
     fakeroot debian/rules binary
     dpkg-genchanges -b >../ixgbe-dkms_3.12.6_amd64.changes
    dpkg-genchanges: binary-only upload - not including any source code
     dpkg-source --after-build ixgbe-dkms-3.12.6
    DKMS: mkdeb completed.
    Moving built files to /var/lib/dkms/ixgbe/3.12.6/deb...
    Cleaning up temporary files...


8. We have a deb! Lets put it in ~

    
    root@server:/usr/src/ixgbe-3.12.6# cp /var/lib/dkms/ixgbe/3.12.6/deb/ixgbe-dkms_3.12.6_all.deb ~


9. So we have a deb. I would like to install it, but we have to get rid of the build files so they will not conflict with the deb we just built:

    
    root@server:/usr/src/ixgbe-3.12.6# rm -r /var/lib/dkms/ixgbe/


10. Now we have a deb that you can install locally, distribute wherever, install across a cluster:

    
    root@server:/usr/src/ixgbe-3.12.6# dpkg -i /root/ixgbe-dkms_3.12.6_all.deb
    Selecting previously unselected package ixgbe-dkms.
    (Reading database ... 56500 files and directories currently installed.)
    Unpacking ixgbe-dkms (from .../root/ixgbe-dkms_3.12.6_all.deb) ...
    Setting up ixgbe-dkms (3.12.6) ...
    Loading new ixgbe-3.12.6 DKMS files...
    First Installation: checking all kernels...
    Building only for 3.2.0-23-generic
    Building for architecture x86_64
    Building initial module for 3.2.0-23-generic
    Done.
    ixgbe:
    Running module version sanity check.
    - Original module
    - Installation
    - Installing to /lib/modules/3.2.0-23-generic/updates/dkms/
    depmod....
    DKMS: install completed.




## [![33657298](/uploads/33657298.jpg)](https://xkyle.com/building-linux-packages-for-kernel-drivers/attachment/33657298/)




## Reading More:





	
  * [https://wiki.xkyle.com/DKMS_Howto](https://wiki.xkyle.com/DKMS_Howto)

	
  * [http://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support](http://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support)


