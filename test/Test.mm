#import <Preferences/Preferences.h>

@interface TestListController: PSListController {
}
@end

@implementation TestListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Test" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
