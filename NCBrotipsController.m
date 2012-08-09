#import <QuartzCore/QuartzCore.h>
#import "BBWeeAppController-Protocol.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define BROKEY @"brotip"

static NSBundle *_NCBrotipsWeeAppBundle = nil;

@interface NCBrotipsController: NSObject <BBWeeAppController, NSXMLParserDelegate> {
	UIView *_view;
	UIImageView *_backgroundView;
	NSXMLParser * rssParser;
	NSMutableDictionary *item;
	NSString *currentElement;
	NSMutableString *currentTitle, *currentLink, *currentContent;
	
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
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:@"http://www.brotips.com/recent.atom"];

	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];

	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];

	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];

	[rssParser parse];
	// Add subviews to _backgroundView (or _view) here.
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];

	if ([elementName isEqualToString:@"entry"]) {
		// clear out our story item caches...
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

	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"entry"]) {
		// save values to an item, then store that item into the array...
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
		//[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"content"]) {
		[currentContent appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {

	//[activityIndicator stopAnimating];
	//[activityIndicator removeFromSuperview];

	NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
	//[newsTable reloadData];
}

- (void)loadPlaceholderView {
	// This should only be a placeholder - it should not connect to any servers or perform any intense
	// data loading operations.
	//
	// All widgets are 316 points wide. Image size calculations match those of the Stocks widget.
	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316.f, [self viewHeight]}}];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	item = [[NSUserDefaults standardUserDefaults] objectForKey:BROKEY];

	UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
	UIImage *stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
	_backgroundView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	_backgroundView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:_backgroundView];
	
	_backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,4,308,137)];
    _backgroundLabel.textAlignment = UITextAlignmentCenter;
    _backgroundLabel.backgroundColor = [UIColor colorWithRed:166.f/255 green:131.f/255 blue:132.f/255 alpha:1];
    _backgroundLabel.font = [UIFont boldSystemFontOfSize:70];
    _backgroundLabel.adjustsFontSizeToFitWidth = YES;
    _backgroundLabel.minimumFontSize = 10.0;
    _backgroundLabel.numberOfLines = 0;
    _backgroundLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    _backgroundLabel.text = @"Brotips";
    //_backgroundLabel.layer.borderColor = [UIColor redColor].CGColor;
	//_backgroundLabel.layer.borderWidth = 1.0f;
    [_view addSubview:_backgroundLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor]; //[UIColor clearColor]
    _titleLabel.font = [UIFont boldSystemFontOfSize:44];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumFontSize = 34;
    _titleLabel.textColor = [UIColor whiteColor];
    //_titleLabel.shadowColor = [UIColor blackColor];
    //_titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _titleLabel.text = (NSString *)[item objectForKey:@"title"];
    _titleLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
    _titleLabel.frame = CGRectMake(260,1,55,145);
    _titleLabel.textAlignment = UITextAlignmentCenter;
    //_titleLabel.layer.borderColor = [UIColor redColor].CGColor;
	//_titleLabel.layer.borderWidth = 1.0f;
    [_view addSubview:_titleLabel];

		//[item objectForKey:@"content"];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,1,250,145)];
    _contentLabel.textAlignment = UITextAlignmentLeft;
    _contentLabel.backgroundColor = [UIColor clearColor]; //[UIColor clearColor]
    _contentLabel.font = [UIFont boldSystemFontOfSize:20];
    _contentLabel.adjustsFontSizeToFitWidth = YES;
    _contentLabel.minimumFontSize = 10.0;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor whiteColor];
    //_contentLabel.shadowColor = [UIColor blackColor];
    //_contentLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _contentLabel.text = (NSString *)[item objectForKey:@"content"];
    //_contentLabel.layer.borderColor = [UIColor redColor].CGColor;
	//_contentLabel.layer.borderWidth = 1.0f;
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
	
	// Destroy any additional subviews you added here. Don't waste memory :(.
}

- (float)viewHeight {
	return 146.f;
}

@end