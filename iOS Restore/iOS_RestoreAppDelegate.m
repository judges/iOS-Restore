//
//  iOS_RestoreAppDelegate.m
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import "iOS_RestoreAppDelegate.h"
#import "JRFWServerManifestGrabber.h"
#import "DeviceIdentification.h"
#import "MDDeviceManager.h"


@implementation iOS_RestoreAppDelegate

static NSImage *redOrbImage = nil;
static NSImage *greenOrbImage = nil;

@synthesize window;
@synthesize statusOrbView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    redOrbImage = [[NSImage imageNamed:@"red-orb.png"] retain];
    greenOrbImage = [[NSImage imageNamed:@"green-orb.png"] retain];
    
    downloadedServerInfo = NO;
    [almightyRestoreButton setEnabled:NO];
    
    [connectedDeviceLabel setStringValue:@"No Device Connected"];
    
    [window setContentBorderThickness:25.0 forEdge:NSMinYEdge];
    [window setMovableByWindowBackground:YES];
    
    [statusOrbView setImage:redOrbImage];
    
    manifestGrabber = [[JRFWServerManifestGrabber alloc] init];
    manifestGrabber.delegate = self;
    
    _currentServerManifest = nil;
    
    [[MDNotificationCenter sharedInstance] addListener:self];
}

- (void)labelDeviceAs:(NSString *)name {
    [connectedDeviceLabel setStringValue:name];
    [self populateServerFirmwarePopupBox];
}

- (void)updateDeviceLabelForDetachedDevice {
    [statusOrbView setImage:redOrbImage];
    [self labelDeviceAs:@"No Device Connected"];
    [almightyRestoreButton setEnabled:NO];
    [self populateServerFirmwarePopupBox];
}

- (void)updateDeviceLabelForProductID:(uint16_t)pid deviceID:(uint32_t)did isRestore:(BOOL)isRestore {
    [statusOrbView setImage:greenOrbImage];
    [self labelDeviceAs:iOSRestoreGetDeviceConnectionType(pid, did, isRestore)];
    
    [self populateServerFirmwarePopupBox];
    
    switch([restoreTypeTabView indexOfTabViewItem:[restoreTypeTabView selectedTabViewItem]]) {
        case 1: {
            if([[[serverFWChoiceButton itemAtIndex:0] title] isEqualToString:@"None Available"])
                [almightyRestoreButton setEnabled:NO];
            else
                [almightyRestoreButton setEnabled:YES];
        }
    }
}
                      
- (void)normalDeviceAttached:(AMDeviceRef)device {
    [self updateDeviceLabelForProductID:AMDeviceUSBProductID(device) deviceID:0 isRestore:NO];
}

- (void)normalDeviceDetached:(AMDeviceRef)device {
    [self updateDeviceLabelForDetachedDevice];
}

- (void)normalDeviceConnectionError {
    [self updateDeviceLabelForDetachedDevice];
}

- (void)restoreDeviceAttached:(AMRestoreModeDeviceRef)device {
    [self updateDeviceLabelForProductID:AMDeviceUSBProductID((AMDeviceRef)device) deviceID:0 isRestore:YES];
}

- (void)restoreDeviceDetached:(AMRestoreModeDeviceRef)device {
    [self updateDeviceLabelForDetachedDevice];
}

- (void)recoveryDeviceAttached:(AMRecoveryModeDeviceRef)device {
    [self updateDeviceLabelForProductID:AMRecoveryModeDeviceGetProductID(device) deviceID:AMRecoveryModeDeviceGetProductType(device) isRestore:NO];
}

- (void)recoveryDeviceDetached:(AMRecoveryModeDeviceRef)device {
    [self updateDeviceLabelForDetachedDevice];
}

- (void)dfuDeviceAttached:(AMDFUModeDeviceRef)device {
    [self updateDeviceLabelForProductID:AMDFUModeDeviceGetProductID(device) deviceID:AMDFUModeDeviceGetProductType(device) isRestore:NO];
}

- (void)dfuDeviceDetached:(AMDFUModeDeviceRef)device {
    [self updateDeviceLabelForDetachedDevice];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [serverDownloadBar stopAnimation:self];
    [sheet orderOut:nil];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSInteger tabIndex = [tabView indexOfTabViewItem:tabViewItem];
    
    if(tabIndex == 0) {
        // for now
        [almightyRestoreButton setEnabled:NO];
    } else if(tabIndex == 1) {
        if(!downloadedServerInfo) {
            [NSApp beginSheet:serverDownloadSheet modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
            [serverDownloadBar startAnimation:self];
            [manifestGrabber performSelector:@selector(beginGrabbing) withObject:nil afterDelay:1.0];

        }
    }
}

- (void)populateServerFirmwarePopupBox {
    [serverFWChoiceButton removeAllItems];
    
    if(![[MDDeviceManager sharedInstance] deviceIsPluggedIn] || _currentServerManifest == nil) {
        [serverFWChoiceButton addItemWithTitle:@"None Available"];
        [almightyRestoreButton setEnabled:NO];
        return;
    }
    
    APPLE_MOBILE_DEVICE *deviceType = [[MDDeviceManager sharedInstance] currentDeviceType];
    
    for(NSString *firmwareVersion in [[_currentServerManifest objectForKey:[NSString stringWithUTF8String:deviceType->model]] allKeys]) {
        [serverFWChoiceButton addItemWithTitle:firmwareVersion];
    }
    
    if([restoreTypeTabView indexOfTabViewItem:[restoreTypeTabView selectedTabViewItem]] == 1) {
        [almightyRestoreButton setEnabled:YES];
    }
}

- (void)serverManifestGrabberDidFinishWithManifest:(NSDictionary *)manifest {
    [NSApp endSheet:serverDownloadSheet];
    downloadedServerInfo = YES;
    
    if(_currentServerManifest != nil) {
        [_currentServerManifest release];
    } 
    
    _currentServerManifest = [manifest retain];
    
    // populate popup box
    [self populateServerFirmwarePopupBox];
}

- (void)serverManifestGrabberFailedWithErrorDescription:(NSString *)errorDescription {
    [NSApp endSheet:serverDownloadSheet];
    [restoreTypeTabView selectTabViewItemAtIndex:0];
}

- (IBAction)browseForIPSW:(id)sender {
    NSOpenPanel *browser = [NSOpenPanel openPanel];
    [browser setAllowsMultipleSelection:NO];
    [browser setAllowedFileTypes:[NSArray arrayWithObject:@"ipsw"]];
    [browser setAllowsOtherFileTypes:NO];
    [browser setPrompt:@"Restore"];
    [browser setCanChooseFiles:YES];
    [browser setTitle:@"Please choose the firmware file you wish to restore to."];
    [browser setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    
    [NSApp runModalForWindow:browser];
}

- (IBAction)attemptRestore:(id)sender {
    // first step, unzip 
}

- (IBAction)serverFirmwareSelectionChange:(id)sender {
    if([[MDDeviceManager sharedInstance] deviceIsPluggedIn] && ![[[sender selectedItem] title] isEqualToString:@"None Available"])
        [almightyRestoreButton setEnabled:YES];
}

- (void)dealloc {
    [manifestGrabber release];
    [redOrbImage release];
    [greenOrbImage release];
    
    [super dealloc];
}

@end
