//
//  MDListener.h
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDevice.h"


@protocol MDListener <NSObject>

@optional
- (void)normalDeviceAttached:(AMDeviceRef)device;
- (void)normalDeviceDetached:(AMDeviceRef)device;
- (void)normalDeviceConnectionError;

- (void)restoreDeviceAttached:(AMRestoreModeDeviceRef)device;
// It is impossible to differentiate between restore and normal mode detachment, will
//  default to using normal

- (void)recoveryDeviceAttached:(AMRecoveryModeDeviceRef)device;
- (void)recoveryDeviceDetached:(AMRecoveryModeDeviceRef)device;

- (void)dfuDeviceAttached:(AMDFUModeDeviceRef)device;
- (void)dfuDeviceDetached:(AMDFUModeDeviceRef)device;

@end
