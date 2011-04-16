//
//  MDNotificationCenter.h
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDListener.h"


@interface MDNotificationCenter : NSObject <MDListener> {
@private
    NSMutableSet *_listeners;
    AMDeviceSubscriptionRef subscription;
}

+ (MDNotificationCenter *)sharedInstance;

- (void)addListener:(id<MDListener>)listener;
- (void)removeListener:(id<MDListener>)listener;

- (void)clearAllListeners;

@end
