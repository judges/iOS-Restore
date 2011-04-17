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
    id<JRFWServerManifestGrabberDelegate> _delegate;
    NSMutableData *_rawResponse;
    BOOL started;
}

- (void)beginGrabbing;

@property (assign) id<JRFWServerManifestGrabberDelegate> delegate;
@property (readonly, getter=hasStarted) BOOL started;

@end


@protocol JRFWServerManifestGrabberDelegate <NSObject>

@optional
- (void)serverManifestGrabberDidFinishWithManifest:(NSDictionary *)manifest;
- (void)serverManifestGrabberFailedWithErrorDescription:(NSString *)errorDescription;

@end