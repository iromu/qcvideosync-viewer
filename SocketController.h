//
//  SocketController.h
//  viewer
//
//  Created by wantez on 19/08/10.
//  Copyright 2010 Ivan Rodriguez Murillo. All rights reserved.
//

#import "SocketControllerDelegate.h"

@class GCDAsyncSocket;

@interface SocketController : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    GCDAsyncSocket*                 asyncSocket;
	BOOL                            connected;
	id<SocketControllerDelegate>    theDelegate;
	
	BOOL                            running;
    NSNetServiceBrowser*            netServiceBrowser;
    NSNetService*                   serverService;
    NSMutableArray*                 serverAddresses;
}

@property (readwrite, strong) id<SocketControllerDelegate> theDelegate;	
@property (readwrite, assign) BOOL running;	

-(id) initWithDelegate: (id<SocketControllerDelegate>) delegate;
-(void) startBrowsing;

@end
