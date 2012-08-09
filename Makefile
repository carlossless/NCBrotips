include theos/makefiles/common.mk

BUNDLE_NAME = NCBrotips
NCBrotips_FILES = NCBrotipsController.m
NCBrotips_INSTALL_PATH = /Library/WeeLoader/Plugins/
NCBrotips_FRAMEWORKS = UIKit CoreGraphics QuartzCore
#NCBrotips_SUBPROJECTS = ncbrotipssettings

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
