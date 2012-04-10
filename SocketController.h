//
//  SocketController.h
//  viewer
//
//  Created by wantez on 19/08/10.
//  Copyright 2010 Ivan Rodriguez Murillo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <common.h>
//#include "AsyncSocket.h"

@class GCDAsyncSocket;

@protocol SocketControllerDelegate <NSObject>
-(void)onCommand:(NSString * ) cmd;
@end


//@class AsyncSocket;
@interface SocketController : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>{
	//AsyncSocket*	socket;
    GCDAsyncSocket *asyncSocket;
	BOOL connected;
	id<SocketControllerDelegate> theDelegate;
	
	BOOL			running;
    NSNetServiceBrowser *netServiceBrowser;
    NSNetService *serverService;
    NSMutableArray *serverAddresses;
}

@property (readwrite, strong) id<SocketControllerDelegate> theDelegate;	
@property (readwrite, assign) BOOL running;	

-(id) initWithDelegate: (id<SocketControllerDelegate>) delegate;
//-(BOOL) connectSocket: (NSString *) host port: (UInt16) port;
-(void) startBrowsing;

@end
/*
@interface SocketController (AsyncSocketDelegate)
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
@end
*/
