//
//  iOS_RestoreAppDelegate.h
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDListener.h"
#import "MDNotificationCenter.h"


@interface iOS_RestoreAppDelegate : NSObject <NSApplicationDelegate, MDListener> {
@private
    NSWindow *window;
    NSImageView *statusOrbView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *statusOrbView;

@end
