//
//  AppController.m
//  viewer
//
//  Created by wantez on 19/07/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "AppController.h"
#import "SocketController.h"

@interface AppController (PrivateAPI)
-(void)startFireDateTimer:(double) delay;
- (void)sendMoviePlayCommand;
- (void)changePlayList:(NSUInteger) number;
- (void)playNext:(NSUInteger) number;
- (NSArray* ) getMoviesAt: (NSString* ) inPath;
-(void) enterFullScreen;
-(void) enterFullScreen2;
- (void)qtMovieEnded:(NSNotification*)notification;
@end

@implementation AppController

@synthesize window;
@synthesize nextMovie;
@synthesize library;
@synthesize currentPlayList;
@synthesize pl1Array;
@synthesize pl2Array;
@synthesize pl3Array;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark AppController private methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)startFireDateTimer:(double) delay 
{
	DDLogVerbose(@"Entering 'startFireDateTimer'.");
	
	double delta = (0.5 + delay) * -1.00;
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:delta];
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:fireDate
											  interval:0.1
												target:self
											  selector:@selector(sendMoviePlayCommand)
											  userInfo:nil//[self userInfo]
											   repeats:NO];
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)sendMoviePlayCommand 
{
	DDLogVerbose(@"Entering 'sendMoviePlayCommand'.");
	[[qtView movie] play];
}

- (void)qtMovieEnded:(NSNotification*)notification
{
    DDLogVerbose(@"Entering 'qtMovieEnded'.");
    [self playNext:nextIndex+1];
	//[[qtView movie] gotoBeginning];
}

-(void) enterFullScreen2
{
	[[self.window contentView] 
     enterFullScreenMode:[self.window screen] 
     withOptions:[NSDictionary dictionaryWithObject:
                  [NSNumber numberWithBool:YES]  
                                             forKey:NSFullScreenModeSetting] ];
    
}

-(void)enterFullScreen
{
	
	if (!fullscreen) {
		
		int windowLevel;
		NSRect screenRect;
		
		// Capture the main display
		if (CGDisplayCapture( kCGDirectMainDisplay ) != kCGErrorSuccess) {
			DDLogVerbose( @"Couldn't capture the main display!" );
		}
		
		// Get the shielding window level
		windowLevel = CGShieldingWindowLevel();
		
		// Get the screen rect of our main display
		screenRect = [[NSScreen mainScreen] frame];
		
		// Put up a new window
		mainWindow = [[NSWindow alloc] initWithContentRect:screenRect
												 styleMask:NSBorderlessWindowMask
												   backing:NSBackingStoreBuffered
													 defer:NO screen:[NSScreen mainScreen]];
		
		[mainWindow setLevel:windowLevel];
		
		[mainWindow setBackgroundColor:[NSColor blackColor]];
		[mainWindow makeKeyAndOrderFront:nil];
		
		// Load our content view
		// [qtView setFrame:screenRect display:YES];
		[mainWindow setContentView:qtView];
		
		CGDisplayHideCursor (kCGNullDirectDisplay);
		CGAssociateMouseAndMouseCursorPosition (false);
		CGDisplayMoveCursorToPoint (kCGDirectMainDisplay, CGPointZero);
		
		fullscreen = YES;
	}
	
}

/*
 -(void) enterFullScreen
 {
 [[self.window contentView] 
 enterFullScreenMode:[self.window screen] 
 withOptions:[NSDictionary dictionaryWithObject:
 [NSNumber numberWithBool:YES]  
 forKey:NSFullScreenModeSetting] ];
 
 }
 */

- (void)changePlayList:(NSUInteger) number {
	DDLogVerbose(@"Entering 'changePlayList'. Number %lu", number);
	
	//[currentPlayList release];
	switch (number) {
		case 1:
			self.currentPlayList = [NSArray arrayWithArray: self.pl1Array];
			break;
		case 2:
			self.currentPlayList = [NSArray arrayWithArray: self.pl2Array];
			break;
		case 3:{
            self.currentPlayList = [NSArray arrayWithArray: self.pl3Array];
			//NSMutableArray* shuffle = [NSMutableArray arrayWithArray: self.pl3Array];
			/*
             NSUInteger count = [shuffle count];
             for (NSUInteger i = 0; i < count; ++i) {
             int nElements = count - i;
             int n = (arc4random() % nElements) + i;
             [shuffle exchangeObjectAtIndex:i withObjectAtIndex:n];
             }
             self.currentPlayList = [NSArray arrayWithArray: shuffle];
             */
			break;
		}
		default:
			break;
	}
	if (nextMovie)	{
        
        //[nextMovie release];
        self.nextMovie=nil;
    }
}

- (void)playNext:(NSUInteger) number 
{
	DDLogVerbose(@"Entering 'playNext'. Number %lu", number);
	
	//[[qtView movie] stop];
	
	NSString* fileName;
	nextIndex = number;
	NSUInteger count = [currentPlayList count];
	
	if (nextIndex >= count) {
		nextIndex = nextIndex % count;
	}
	
	DDLogVerbose(@"Loading index %lu/%lu", nextIndex,count);
	
	/*
     QTTime duration = [[qtView movie] duration];
     QTTime currentTime = [[qtView movie] currentTime];
     
     DDLogVerbose(@"Duration %llu/%lu,%lu", duration.timeValue, duration.timeScale, duration.flags);
     DDLogVerbose(@"currentTime %llu/%lu,%lu", currentTime.timeValue, currentTime.timeScale, currentTime.flags);
     */
	
	//[[qtView movie] autorelease];
	/*
     if(!nextMovie){
     NSUInteger oldIndex = nextIndex-1;
     if(nextIndex == 0)oldIndex = count-1;
     DDLogVerbose(@"Pre-loading first movie %@", [currentPlayList objectAtIndex: oldIndex]);
     fileName = [currentPlayList objectAtIndex: oldIndex];
     
     QTMovie *movie_ = [[QTMovie alloc] initWithFile:fileName error:nil];
     
     [self setNextMovie:movie_];
     
     //self.nextMovie = [[QTMovie alloc] initWithFile:[currentPlayList objectAtIndex: oldIndex] error:NULL];
     //[nextMovie retain];
     
     }*/
	/*
	 else {
	 [nextMovie release];
	 }*/
	
	//if([QTMovie canInitWithFile: [currentPlayList objectAtIndex: nextIndex]] ){
	DDLogVerbose(@"Loading next movie %@", [currentPlayList objectAtIndex: nextIndex]);
	//[qtView setMovie: nil];
	//[[qtView movie] dealloc];
	//[qtView setMovie:NULL];
	//[qtView setControllerVisible:NO];
	//[qtView setMovie: [self nextMovie]];
	
	
	
	fileName = [currentPlayList objectAtIndex: nextIndex];
	/*
     NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
     fileName, QTMovieFileNameAttribute,
     [NSNumber numberWithBool:YES], nil];
     QTMovie *movie_ = [[QTMovie alloc] initWithAttributes:attributes error:NULL];
     */
	
	QTMovie *movie_ = [[QTMovie alloc] initWithFile:fileName error:nil];
	
	[qtView setMovie: movie_];
	movie_=nil;
	
	[[qtView movie] play];
	
	//[self setNextMovie:nil];
	
	//[nextMovie release];
	
	//self.nextMovie=nil;
	//fileName = [currentPlayList objectAtIndex: nextIndex];
	
	//QTMovie *movie_ = [[QTMovie alloc] initWithFile:fileName error:nil];
	//[self setNextMovie:movie_];
	
	//self.nextMovie = [[QTMovie alloc] initWithFile:[currentPlayList objectAtIndex: nextIndex] error:NULL];
	//[nextMovie retain];
	//[nextMovie autorelease];
	//[newmovie release];
	//}
	
}

/*
 - (void)setNextMovie:(QTMovie *)movie_
 {
 [movie_ retain];
 //[movie_ autorelease];
 [nextMovie release];
 nextMovie=nil;
 nextMovie = movie_;
 
 }
 */

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSApplication delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillTerminate:(NSNotification *)notification
{
	DDLogVerbose(@"Entering 'applicationWillTerminate'.");
	[mainWindow orderOut:self];
	
	// Release the display(s)
	if (CGDisplayRelease( kCGDirectMainDisplay ) != kCGErrorSuccess) {
		DDLogVerbose( @"Couldn't release the display(s)!" );
		// Note: if you display an error dialog here, make sure you set
		// its window level to the same one as the shield window level,
		// or the user won't see anything.
	}
	CGAssociateMouseAndMouseCursorPosition (true);
	CGDisplayShowCursor (kCGNullDirectDisplay);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Configure logging framework
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	[DDLog addLogger:[DDASLLogger sharedInstance]];
    
	DDLogVerbose(@"Entering 'applicationDidFinishLaunching'.");
	
#ifdef RELEASE
    [self enterFullScreen ];
#endif
    
	self.library = @"/Users/Shared/Movies";
	
	NSString* pl1Path = [NSString stringWithFormat: @"%@/PL1", library];
	NSString* pl2Path = [NSString stringWithFormat: @"%@/PL2", library];
	NSString* pl3Path = [NSString stringWithFormat: @"%@/PL3", library];
	
	self.pl1Array = [self getMoviesAt: pl1Path];
	self.pl2Array = [self getMoviesAt: pl2Path];
	self.pl3Array = [self getMoviesAt: pl3Path];
	
	self.currentPlayList = [NSArray arrayWithArray: self.pl1Array];
	
	DDLogVerbose(@"pl1Array count %lu",[pl1Array count]);
	DDLogVerbose(@"pl2Array count %lu",[pl2Array count]);
	DDLogVerbose(@"pl3Array count %lu",[pl3Array count]);
	
	DDLogVerbose(@"currentPlayList count %lu",[currentPlayList count]);
	
	[qtView setControllerVisible:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qtMovieEnded:)
                                                 name:QTMovieDidEndNotification object:qtView.movie];
	
	clientSocket = [[SocketController alloc] initWithDelegate: (id<SocketControllerDelegate>)self];
	[clientSocket startBrowsing];
}

- (NSArray* ) getMoviesAt: (NSString* ) inPath
{
	NSMutableArray* movies = [NSMutableArray array];
	//NSArray* filesAtPath = [[NSFileManager defaultManager] directoryContentsAtPath:inPath];
	NSArray* filesAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:inPath error:nil];
	NSEnumerator* itr = [filesAtPath objectEnumerator];
	NSString* obj;
	NSString* fileName;
	while ((obj = [itr nextObject]))
	{
		if ( ![obj hasPrefix:@"."] ) {
			fileName = [NSString stringWithFormat: @"%@/%@", inPath, obj];
			DDLogVerbose(@"Loading movie %@",fileName);
			//QTMovie* newmovie = [[QTMovie alloc] initWithFile:fileName error:NULL];
			[movies addObject: fileName];
			//[newmovie release];
		}
	}
	
	//return filesAtPath;
	return [NSArray arrayWithArray: movies];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSWindow delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (void)windowWillClose:(NSNotification *)notification 
{
	DDLogVerbose(@"Entering 'windowWillClose'.");
	[NSApp terminate:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark SocketController delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)onCommand:(NSString * ) command{
	
	//NSAutoreleasePool *pool = [NSAutoreleasePool new];
	command = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	DDLogVerbose(@"Entering 'onCommand': '%@' ", command);
	
	//**double CurrentTime = [[NSDate date] timeIntervalSince1970];
	//**double lag,seconds;
	
	if ([command hasPrefix:@"START"]) {
		DDLogVerbose(@"Entering 'onCommand.START'.");
		//[self enterFullScreen ];
		
		// lag delta calculation
		//**seconds = (CurrentTime - [[command substringFromIndex:6] doubleValue] );
		//**lag = seconds * 1000.00;
		//DDLogVerbose(@"START lag: %f ms", lag);	
		//[self startFireDateTimer: seconds];
		//**[NSThread sleepForTimeInterval:(1.00-seconds)];
		
		[qtView play:self];
		
	}else if ([command hasPrefix:@"NEXT"]) {
		DDLogVerbose(@"Entering 'onCommand.NEXT' %d.", [[command substringFromIndex:5] intValue]);
		
		[self playNext: [[command substringFromIndex:5] intValue]];
	}
	else if ([command hasPrefix:@"PL"]) {
		DDLogVerbose(@"Entering 'onCommand.PL'.");
		
		[self changePlayList: [[command substringWithRange: NSMakeRange(3,1)] intValue]];
		
		if ([command length] >5 && [[command substringFromIndex: 5] hasPrefix:@"NEXT"]) {
			DDLogVerbose(@"Entering 'onCommand.NEXT' %d.", [[command substringFromIndex:10] intValue]);
			[self playNext: [[command substringFromIndex:10] intValue]];
			
			command = [command substringFromIndex:[command rangeOfString:@"CT"].location];
			
			DDLogVerbose(@"Entering 'onCommand.CT'.");
			
			/*
             long long		timeValue;
             long			timeScale;
             long			flags;
             */
			
			QTTime duration = [[qtView movie] duration];
			QTTime currentTime = [[qtView movie] currentTime];
			
			DDLogVerbose(@"Duration %llu/%lu,%lu", duration.timeValue, duration.timeScale, duration.flags);
			DDLogVerbose(@"currentTime %llu/%lu,%lu", currentTime.timeValue, currentTime.timeScale, currentTime.flags);
			
			[[qtView movie] stop];
			long long interval = [[command substringFromIndex:3] longLongValue];
			DDLogVerbose(@"Interval millis %llu",interval/1000000LLU);
			
			
			
			/*
			 
			 
			 QTTime theTime = [theMovie currentTime];
			 theTime.movieTime = requiredStartTime * theTime.timeScale;
			 
			 [theMovie setCurrentTime: theTime];
			 
			 [dummyMovieView setMovie: theMovie];
			 [dummyMovieView setMovie: NULL];
			 
			 */
			
			//currentTime.movieTime= interval* currentTime.timeScale;
			
			[[qtView movie] setCurrentTime: QTMakeTime((interval* currentTime.timeScale)/(1000000000LLU), currentTime.timeScale)];
			[[qtView movie] play];
			
			duration = [[qtView movie] duration];
			currentTime = [[qtView movie] currentTime];
			
			DDLogVerbose(@"Duration %llu/%lu,%lu", duration.timeValue, duration.timeScale, duration.flags);
			DDLogVerbose(@"currentTime %llu/%lu,%lu", currentTime.timeValue, currentTime.timeScale, currentTime.flags);
			
		}
	}
	else if ([command hasPrefix:@"STOP"]) {
		DDLogVerbose(@"Entering 'onCommand.STOP'.");
		[[qtView movie] stop];
        //	[[qtView movie] gotoBeginning];
		//[qtView setMovie: nil];
		/*if(nextMovie){
		 [nextMovie release];
		 self.nextMovie = nil;
		 }*/
	}
	
	//[pool release];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end