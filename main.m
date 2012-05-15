//
//  main.m
//  viewer
//
//  Created by wantez on 19/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {

        int retVal = NSApplicationMain(argc, (const char * *) argv);

        //[pool drain];

        return retVal;
    }

    //return NSApplicationMain(argc,  (const char **) argv);
}

