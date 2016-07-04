NCBrotips
=========

*NCBrotips is no longer supported and was never meant to be supported on future iOS releases, this repo acts only as a archive*.

------------

NCBrotips is an iPhone Notification Center widget that finds and retrieves the latest
tip from http://brotips.com. It was made solely to test some simple widget capabilities
on a jailbroken iPhone.

![NCBrotips](https://cloud.githubusercontent.com/assets/498906/16568255/ac2c258e-4230-11e6-851c-bb860abe94ce.png)

Building NCBrotips
-------------

To build NCBrotips you'll need to get the latest theos makefile system https://github.com/DHowett/theos.
After you install it just edit the symbolic link in NCBrotips to match your own theos
path and run:

	$ make package install

Also, make sure you set your theos path and device ip before trying to install:

	$ export THEOS=/opt/theos
	$ export THEOS_DEVICE_IP=192.168.1.1
	
Just getting NCBrotips on your iPhone
-------------

If you don't want to build NCBrotips you can get the latest stable binary release from my cydia repo. 
Just add the following line to your package sources:

	http://repo.sdgears.info
	
	
