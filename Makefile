include theos/makefiles/common.mk

BUNDLE_NAME = NCBrotips
NCBrotips_FILES = NCBrotipsController.m
NCBrotips_INSTALL_PATH = /Library/WeeLoader/Plugins/
NCBrotips_FRAMEWORKS = UIKit CoreGraphics QuartzCore
SUBPROJECTS = ncbrotipssettings

include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk

before-package::
	@cp cydia_scripts/* _/DEBIAN/

after-install::
	install.exec "killall -9 SpringBoard"
