//
//  JRFWServerManifest.h
//  iOS Restore
//
//  Created by John Heaton on 4/16/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JRFWServerManifest : NSObject {
@private
    NSDictionary *_rawManifest;
    NSArray *_fwVersionTitles;
}

@end
