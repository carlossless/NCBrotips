#import <QuartzCore/QuartzCore.h>
#import "BBWeeAppController-Protocol.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define dc2fc(color) (color / 255.f)

#define BROKEY @"brotip"

#define SETTINGS @"BrotipSource"
#define RECENT @"Recent"
#define POPULAR @"Popular"
#define RANDOM @"Random"

#define POPULAR_URL @"http://www.brotips.com/popular.atom"
#define RECENT_URL @"http://www.brotips.com/recent.atom"
#define RANDOM_URL @"http://www.brotips.com/random.atom"

static NSBundle *_NCBrotipsWeeAppBundle = nil;

@interface NCBrotipsController: NSObject <BBWeeAppController, NSXMLParserDelegate> {
	UIView *_view;
	UIImageView *_backgroundView;
	NSXMLParser * rssParser;
	NSMutableDictionary *item;
	NSString *currentElement;
	NSMutableString *currentTitle, *currentLink, *currentContent;
	NSArray *colorArray;
	
	UILabel *_titleLabel;
	UILabel *_contentLabel;
	UILabel *_backgroundLabel;
	UIButton *_btn;
}
@property (nonatomic, retain) UIView *view;
@end

@implementation NCBrotipsController
@synthesize view = _view;

+ (void)initialize {
	_NCBrotipsWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init {
	if((self = [super init]) != nil) {
		
	} return self;
}

- (void)dealloc {
	[_view release];
	[_backgroundView release];
	[super dealloc];
}

- (void)loadFullView {
    NSString *sourceKey = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS];
    NSString *urlString;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS]);
    
    if ([sourceKey isEqualToString:POPULAR]) {
        urlString = POPULAR_URL;
    } else if ([sourceKey isEqualToString:RANDOM]) {
        urlString = RANDOM_URL;
    } else { //Everything else goes to recent
        urlString = RECENT_URL;
    }
    
	NSURL *xmlURL = [NSURL URLWithString:urlString];
    
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[rssParser setDelegate:self];

	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];

	[rssParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];

	if ([elementName isEqualToString:@"entry"]) {
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentContent = [[NSMutableString alloc] init];
	}
	
	if ([elementName isEqualToString:@"link"]) {
		currentLink = [(NSString *)[attributeDict objectForKey:@"href"] mutableCopy];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

	if ([elementName isEqualToString:@"entry"]) {
		currentTitle = [[currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
		[currentTitle deleteCharactersInRange:NSMakeRange([currentTitle length]-1, 1)];
		currentContent = [[[[[currentContent stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
		
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentContent forKey:@"content"];
		
		_titleLabel.text = currentTitle;
		_contentLabel.text = currentContent;
		
		[[NSUserDefaults standardUserDefaults] setObject:item forKey:BROKEY];
		
		[parser abortParsing];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"content"]) {
		[currentContent appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {

}

- (void)loadPlaceholderView {

	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316.f, [self viewHeight]}}];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	colorArray = [NSArray arrayWithObjects:
						[UIColor colorWithRed:dc2fc(176) green:dc2fc(132) blue:dc2fc(133) alpha:1],	//Pink
						[UIColor colorWithRed:dc2fc(188) green:dc2fc(172) blue:dc2fc(153) alpha:1],	//Brown
						[UIColor colorWithRed:dc2fc(136) green:dc2fc(175) blue:dc2fc(131) alpha:1],	//Green
						[UIColor colorWithRed:dc2fc(132) green:dc2fc(173) blue:dc2fc(175) alpha:1],	//Blue
						[UIColor colorWithRed:dc2fc(81) green:dc2fc(116) blue:dc2fc(86) alpha:1],	//Dark Green
						[UIColor colorWithRed:dc2fc(116) green:dc2fc(131) blue:dc2fc(146) alpha:1],	//Purple
						[UIColor colorWithRed:dc2fc(140) green:dc2fc(107) blue:dc2fc(74) alpha:1],	//Dark Brown
					nil];
	
	item = [[NSUserDefaults standardUserDefaults] objectForKey:BROKEY];
	currentContent = [(NSString *)[item objectForKey:@"content"] mutableCopy];
	currentTitle = [(NSString *)[item objectForKey:@"title"] mutableCopy];
	currentLink = [(NSString *)[item objectForKey:@"link"] mutableCopy];

	UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
	UIImage *stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
	_backgroundView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	_backgroundView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:_backgroundView];
	
	_backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.f,4.f,_view.frame.size.width - 12.f,_view.frame.size.height - 9.f)];
	_backgroundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backgroundLabel.textAlignment = UITextAlignmentCenter;
    _backgroundLabel.backgroundColor = (UIColor *)[colorArray objectAtIndex:([[currentTitle substringWithRange:(NSRange){1,[currentTitle length] - 1}] intValue] % [colorArray count])];
    _backgroundLabel.font = [UIFont boldSystemFontOfSize:70.f];
    _backgroundLabel.adjustsFontSizeToFitWidth = YES;
    _backgroundLabel.minimumFontSize = 10.f;
    _backgroundLabel.numberOfLines = 0;
    _backgroundLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    _backgroundLabel.text = @"Brotips";
    [_view addSubview:_backgroundLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:44.f];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumFontSize = 34.f;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = currentTitle;
    _titleLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
    _titleLabel.frame = CGRectMake(_view.frame.size.width - 56.f,1.f,55.f,145.f);
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.textAlignment = UITextAlignmentCenter;
    [_view addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f,1.f,250.f,145.f)];
    _contentLabel.textAlignment = UITextAlignmentLeft;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:20.f];
    _contentLabel.adjustsFontSizeToFitWidth = YES;
    _contentLabel.minimumFontSize = 10.f;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.text = currentContent;
    [_view addSubview:_contentLabel];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = _backgroundView.frame;
    [_btn addTarget:self action:@selector(brotipTouched) forControlEvents:UIControlEventTouchDown];
	[_view addSubview:_btn];
}

- (void)brotipTouched {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: currentLink]];
}

- (void)unloadView {
	[_view release];
	_view = nil;
	[_backgroundView release];
	_backgroundView = nil;
    [_backgroundLabel release];
//	_backgroundLabel = nil;
//	[_titleLabel release];
//	_titleLabel = nil;
//    [_contentLabel release];
//	_contentLabel = nil;
//    [_btn release];
//	_btn = nil;
}

- (float)viewHeight {
	return 146.f;
}

@end
