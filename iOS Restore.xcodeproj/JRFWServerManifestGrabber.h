//
//  JRFWServerManifestGrabber.h
//  iOS Restore
//
//  Created by John Heaton on 4/16/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRFWServerManifestGrabberDelegate;

@interface JRFWServerManifestGrabber : NSObject {
@private
    
}

@end

@protocol JRFWServerManifestGrabberDelegate <NSObject>

@optional
- (void)serverManifestGrabberDidBeginDownloading:(JRFWServerManifestGrabber *)grabber;
- (void)serverManifestGrabberDidFinishWithManifest:(NSDictionary *)manifest;
- (void)serverManifestGrabberFailedWithError:(NSError *)error;

@end