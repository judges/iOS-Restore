//
//  JRRestoreController.h
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDListener.h"

@interface JRRestoreController : NSObject <MDListener> {
@private
    NSString *ipswPath;
    NSString *deflationDirectory;
}



@end
