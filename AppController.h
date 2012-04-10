//
//  AppController.h
//  viewer
//
//  Created by wantez on 19/07/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <Quartz/Quartz.h>
#import <QTKit/QTKit.h>
#import "SocketController.h"

//@class SocketController;
@interface AppController : NSObject<SocketControllerDelegate>

{
	//id			delegate;
    //IBOutlet QCView *qcView;
	IBOutlet QTMovieView *qtView;
	NSWindow *__unsafe_unretained window;
	NSWindow *mainWindow;
	//AsyncSocket *socket;
	//QTMovie *movie;
	QTMovie *movieTest;
	BOOL fullscreen;
	
	//NSString * host;// = "localhost";
	
	//(NSString *) host = "192.168.1.1";
	
	//UInt16 port;// = 8888;
	
//@private
	NSString*	__weak library;
	NSArray*	currentPlayList;
	NSArray*	pl1Array;
	NSArray*	pl2Array;
	NSArray*	pl3Array;
	NSUInteger	nextIndex;
	QTMovie*	__weak nextMovie;
	
	SocketController*	clientSocket;
    
   
	
}
@property (readwrite, weak) NSString*	library;

@property (readwrite, strong) NSArray*	currentPlayList;
@property (readwrite, weak) QTMovie*	nextMovie;
@property (readwrite, strong) NSArray*	pl1Array;
@property (readwrite, strong) NSArray*	pl2Array;
@property (readwrite, strong) NSArray*	pl3Array;

//@property (readwrite, retain) id delegate;	
@property (unsafe_unretained) IBOutlet NSWindow *window;
//@property (retain) AsyncSocket *socket;

//- (void)setNextMovie:(QTMovie *)movie;

//- (NSDictionary *)userInfo;

//@property (retain) QTMovie *movie;
//- (IBAction) changeColorToBlue:(id)sender;
-(void) enterFullScreen;
-(void) enterFullScreen2;

@end


@interface AppController (SocketControllerDelegate)
-(void)onCommand:(NSString * ) cmd;
@end
 
