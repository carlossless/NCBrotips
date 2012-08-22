#import <Preferences/Preferences.h>

@interface NCBrotipsSettingsListController: PSListController {
}
@end

@implementation NCBrotipsSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"NCBrotipsSettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
