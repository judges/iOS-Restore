//
//  MDDeviceManager.m
//  iOS Restore
//
//  Created by John Heaton on 4/17/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import "MDDeviceManager.h"
#import "MDNotificationCenter.h"


@implementation MDDeviceManager

static MDDeviceManager *sharedMDDeviceManager = nil;

@synthesize currentDeviceMode;
@synthesize currentDFUDevice;
@synthesize currentNormalDevice;
@synthesize currentRestoreDevice;
@synthesize currentRecoveryDevice;

- (id)init {
    if((self = [super init]) != nil) {
        [[MDNotificationCenter sharedInstance] addListener:self];
    }
    
    return self;
}

+ (MDDeviceManager *)sharedInstance {
    @synchronized(self) {
        if (!sharedMDDeviceManager) {
            sharedMDDeviceManager = [[self alloc] init];
        }
    }
    
	return sharedMDDeviceManager;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {}

- (id)retain {
    return sharedMDDeviceManager;
}

- (id)autorelease {
    return sharedMDDeviceManager;
}

- (void)normalDeviceAttached:(AMDeviceRef)device {
    currentNormalDevice = device;
    currentDeviceMode = kAMDeviceNormalMode;
}

- (void)normalDeviceDetached:(AMDeviceRef)device {
    if(currentDeviceMode == kAMDeviceNormalMode) {
        currentNormalDevice = NULL;
    } else {
        currentRestoreDevice = NULL;
    }

    currentDeviceMode = kAMDeviceNoMode;
}

- (void)restoreDeviceAttached:(AMRestoreModeDeviceRef)device {
    currentRestoreDevice = device;
}

- (void)recoveryDeviceAttached:(AMRecoveryModeDeviceRef)device {
    currentRecoveryDevice = device;
    currentDeviceMode = kAMDeviceRecoveryMode;
}

- (void)recoveryDeviceDetached:(AMRecoveryModeDeviceRef)device {
    currentRecoveryDevice = NULL;
    currentDeviceMode = kAMDeviceNoMode;
}

- (void)dfuDeviceAttached:(AMDFUModeDeviceRef)device {
    currentDFUDevice = device;
    currentDeviceMode = kAMDeviceDFUMode;
}

- (void)dfuDeviceDetached:(AMDFUModeDeviceRef)device {
    currentDFUDevice = NULL;
    currentDeviceMode = kAMDeviceNoMode;
}

@end
