//
//  AppController.h
//  viewer
//
//  Created by wantez on 19/07/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <QTKit/QTKit.h>
#import "SocketControllerDelegate.h"

@class SocketController;

@interface AppController : NSObject <NSApplicationDelegate,SocketControllerDelegate>
{
	IBOutlet QTMovieView*           qtView;
	NSWindow*   __unsafe_unretained window;
	NSWindow*                       mainWindow;
	QTMovie*                        movieTest;
	BOOL                            fullscreen;
	NSString*	__weak              library;
	NSArray*                        currentPlayList;
	NSArray*                        pl1Array;
	NSArray*                        pl2Array;
	NSArray*                        pl3Array;
	NSUInteger                      nextIndex;
	QTMovie*	__weak              nextMovie;
	SocketController*               clientSocket;
}

@property (readwrite, weak)     NSString*	library;
@property (readwrite, strong)   NSArray*	currentPlayList;
@property (readwrite, weak)     QTMovie*	nextMovie;
@property (readwrite, strong)   NSArray*	pl1Array;
@property (readwrite, strong)   NSArray*	pl2Array;
@property (readwrite, strong)   NSArray*	pl3Array;	
@property (unsafe_unretained)   IBOutlet NSWindow *window;

@end