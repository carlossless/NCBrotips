NCBrotips
=========

NCBrotips is an iPhone Notification Center widget that finds and retrieves the latest
tip from http://brotips.com. It was made solely to test some simple widget capabilities
on a jailbroken iPhone.

![NCBrotips](http://mindw0rk.sdgears.info/~work/NCBrotips.png "NCBrotips")

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
	
	
