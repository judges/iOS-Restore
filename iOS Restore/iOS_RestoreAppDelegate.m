//
//  iOS_RestoreAppDelegate.m
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import "iOS_RestoreAppDelegate.h"

@implementation iOS_RestoreAppDelegate

@synthesize window;
@synthesize statusOrbView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [window setContentBorderThickness:25.0 forEdge:NSMinYEdge];
    [window setMovableByWindowBackground:YES];
    
    [statusOrbView setImage:[NSImage imageNamed:@"red-orb.png"]];
    
    [[MDNotificationCenter sharedInstance] addListener:self];
}

- (void)normalDeviceAttached:(AMDeviceRef)device {
    NSLog(@"iOS Restore: Normal Attached");
    [statusOrbView setImage:[NSImage imageNamed:@"green-orb.png"]];
}

- (void)normalDeviceDetached:(AMDeviceRef)device {
    NSLog(@"iOS Restore: Normal Detached");
    [statusOrbView setImage:[NSImage imageNamed:@"red-orb.png"]];
}

- (void)normalDeviceConnectionError {
    NSLog(@"iOS Restore: Normal Error");
}

- (void)restoreDeviceAttached:(AMRestoreModeDeviceRef)device {
    NSLog(@"iOS Restore: Restore Attached");
    [statusOrbView setImage:[NSImage imageNamed:@"green-orb.png"]];
}
// It is impossible to differentiate between restore and normal mode detachment, will
//  default to using normal

- (void)recoveryDeviceAttached:(AMRecoveryModeDeviceRef)device {
    NSLog(@"iOS Restore: Recovery Attached");
    [statusOrbView setImage:[NSImage imageNamed:@"green-orb.png"]];
    
    CFShow(AMRecoveryModeDeviceCopyBoardConfig(device));
}

- (void)recoveryDeviceDetached:(AMRecoveryModeDeviceRef)device {
    NSLog(@"iOS Restore: Recovery Detached");
    [statusOrbView setImage:[NSImage imageNamed:@"red-orb.png"]];
}

- (void)dfuDeviceAttached:(AMDFUModeDeviceRef)device {
    NSLog(@"iOS Restore: DFU Attached");
    [statusOrbView setImage:[NSImage imageNamed:@"green-orb.png"]];
}

- (void)dfuDeviceDetached:(AMDFUModeDeviceRef)device {
    NSLog(@"iOS Restore: DFU Detached");
    [statusOrbView setImage:[NSImage imageNamed:@"red-orb.png"]];
}

@end
