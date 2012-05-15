//
//  SocketController.m
//  viewer
//
//  Created by wantez on 19/08/10.
//  Copyright 2010 Ivan Rodriguez Murillo. All rights reserved.
//

#import "SocketController.h"
#import "GCDAsyncSocket.h"

@interface SocketController (Private)
- (void)connectToNextAddress;
@end

@implementation SocketController

@synthesize theDelegate;
@synthesize running;

- (id) initWithDelegate:(id<SocketControllerDelegate>)delegate
{
    DDLogVerbose(@"Entering 'SocketController.initWithDelegate'.");
    //self = [super init];
    [self setTheDelegate:delegate];

    DDLogVerbose (@"SocketController.initWithDelegate :: Creating Client socket.");
    //socket = [[AsyncSocket alloc] initWithDelegate:self];

    //[socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    connected = NO;

    running = NO;

    return self;
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//- (void)onSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    DDLogVerbose(@"Entering 'SocketController.onSocket.didReadData.withTag'.");

    //[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:NO_TIMEOUT tag:0];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if ([str hasPrefix:@"CMD "]) {
        NSString *command = [str substringFromIndex:4];
        if ([theDelegate respondsToSelector:@selector(onCommand:)]) {
            [theDelegate onCommand:command];
        }
    }else if ([str hasPrefix:@"Tick "])  {
        //else if(tag == TICK_MSG){
        [sock writeData:data withTimeout:NO_TIMEOUT tag:TICK_MSG];
        //double CurrentTime = [[NSDate date] timeIntervalSince1970];
        //double lag = (CurrentTime - [[str substringFromIndex:5] doubleValue] ) * 1000.00;
        //DDLogVerbose(@"lag: %f ms", lag);
    }else if ([str hasPrefix:@"WARNING "])  {
        DDLogVerbose(@"Recieved: %@", str);
        NSString *warningMsg = @"ACK \r\n";
        NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];

        [sock writeData:warningData withTimeout:NO_TIMEOUT tag:WARNING_MSG];
    }else {
        DDLogVerbose(@"UNK %@", str);
        NSString *warningMsg = FORMAT(@"UNK %@c", str);
        NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];

        [sock writeData:warningData withTimeout:NO_TIMEOUT tag:WARNING_MSG];
    }

    // Read more from this socket.
    //NSData *newline = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    //[sock readDataToData:newline withTimeout:-1 tag:tag];


    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:NO_TIMEOUT tag:0];
}


/*
   - (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
   //- (void)onSocket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
   {
   DDLogVerbose(@"Entering 'SocketController.socketDidDisconnect.withError'.");

   }*/
/*
   - (void)onSocketDidDisconnect:(GCDAsyncSocket *)sock
   {
   DDLogVerbose(@"Entering 'SocketController.onSocketDidDisconnect'.");

   [NSThread sleepForTimeInterval:(1.00)];

   //[self connectSocket: @"localhost" port:8888];

   //[self connectSocket: @"192.168.1.11" port:8888];
   }
 */
- (void) startBrowsing
{
    // Start browsing for bonjour services

    netServiceBrowser = [[NSNetServiceBrowser alloc] init];

    [netServiceBrowser setDelegate:self];
    [netServiceBrowser searchForServicesOfType:@"_QCVideoSync._tcp." inDomain:@"local."];
}


- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    DDLogVerbose(@"netServiceBrowserDidStopSearch: %@", aNetServiceBrowser);
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
    DDLogVerbose(@"DidNotSearch: %@", errorInfo);
    //[NSThread sleepForTimeInterval:(1.00)];
    //[netServiceBrowser searchForServicesOfType:@"_QCVideoSync._tcp." inDomain:@"local."];
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
   didFindService:(NSNetService *)netService
   moreComing:(BOOL)moreServicesComing
{
    DDLogVerbose(@"netServiceBrowser:didFindService: %@", [netService name]);

    // Connect to the first service we find

    if (serverService == nil) {
        DDLogVerbose(@"Resolving...");

        serverService = netService;

        [serverService setDelegate:self];
        [serverService resolveWithTimeout:5.0];
    }
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
   didRemoveService:(NSNetService *)netService
   moreComing:(BOOL)moreServicesComing
{
    DDLogVerbose(@"DidRemoveService: %@", [netService name]);
    serverService = nil;
    serverAddresses = nil;
    //asyncSocket = nil;
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    DDLogVerbose(@"netService:didNotResolve");
}


- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    DDLogVerbose(@"netServiceDidResolveAddress: %@", [sender addresses]);

    if (serverAddresses == nil) {
        serverAddresses = [[sender addresses] mutableCopy];
    }

    // [self connectSocket: @"localhost" port:8888];

    if (asyncSocket == nil) {
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    [self connectToNextAddress];
}


- (void)connectToNextAddress
{
    BOOL done = NO;

    while (!done && ([serverAddresses count] > 0)) {
        NSData *addr;

        // Note: The serverAddresses array probably contains both IPv4 and IPv6 addresses.
        //
        // If your server is also using GCDAsyncSocket then you don't have to worry about it,
        // as the socket automatically handles both protocols for you transparently.

        if (YES) {       // Iterate forwards
            addr = [serverAddresses objectAtIndex:0];
            [serverAddresses removeObjectAtIndex:0];
        }else {      // Iterate backwards
            addr = [serverAddresses lastObject];
            [serverAddresses removeLastObject];
        }

        DDLogVerbose(@"Attempting connection to %@", addr);

        NSError *err = nil;
        if ([asyncSocket connectToAddress:addr error:&err]) {
            done = YES;
        }else {
            DDLogVerbose(@"Unable to connect: %@", err);
        }
    }

    if (!done) {
        DDLogVerbose(@"Unable to connect to any resolved address");
        //[NSThread sleepForTimeInterval:(1.00)];
        //  [netServiceBrowser searchForServicesOfType:@"_QCVideoSync._tcp." inDomain:@"local."];
    }
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DDLogVerbose(@"socket:DidConnectToHost: %@ Port: %hu", host, port);

    connected = YES;
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:NO_TIMEOUT tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DDLogVerbose(@"socketDidDisconnect:WithError: %@", err);

    if (!connected) {
        [self connectToNextAddress];
    }else {
        //[NSThread sleepForTimeInterval:(1.00)];
        // [netServiceBrowser searchForServicesOfType:@"_QCVideoSync._tcp." inDomain:@"local."];
    }
}


- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    DDLogVerbose(@"socketDidCloseReadStream");
}


@end
