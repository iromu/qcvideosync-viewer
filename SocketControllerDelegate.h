//
//  SocketControllerDelegate.h
//  viewer
//
//  Created by Iván Rodríguez Murillo on 11/04/12.
//  Copyright (c) 2012 Ivan Rodriguez Murillo. All rights reserved.
//

@protocol SocketControllerDelegate <NSObject>
-(void)onCommand:(NSString * ) cmd;
@end
