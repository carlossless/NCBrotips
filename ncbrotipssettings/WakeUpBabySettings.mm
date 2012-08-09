#import <Preferences/Preferences.h>

@interface WakeUpBabySettingsListController: PSListController {
}
@end

@implementation WakeUpBabySettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"WakeUpBabySettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
