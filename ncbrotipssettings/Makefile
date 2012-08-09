include theos/makefiles/common.mk

BUNDLE_NAME = WakeUpBabySettings
WakeUpBabySettings_FILES = WakeUpBabySettings.mm
WakeUpBabySettings_INSTALL_PATH = /Library/PreferenceBundles
WakeUpBabySettings_FRAMEWORKS = UIKit
WakeUpBabySettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WakeUpBabySettings.plist$(ECHO_END)
