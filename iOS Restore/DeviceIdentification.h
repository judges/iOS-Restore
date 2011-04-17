//
//  DeviceIdentification.h
//  iOS Restore
//
//  Created by John Heaton on 4/15/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#ifndef DEVICEIDENTIFICATION_H
#define DEVICEIDENTIFICATION_H

#import <Foundation/Foundation.h>
#include <stdint.h>

typedef struct {
    const char *name;
    uint16_t productID;
    const char *model;
    const char *board;
    uint32_t dfuDeviceID; // From apple's versions plist
    uint32_t recoveryDeviceID; // ^
} APPLE_MOBILE_DEVICE;

#define NUM_APPLE_MOBILE_DEVICES 13

static APPLE_MOBILE_DEVICE APPLE_MOBILE_DEVICES[NUM_APPLE_MOBILE_DEVICES] = {
    { "iPhone",         0x1290, "iPhone1,1",   "m68ap", 304222464,  310382848 },
    { "iPhone 3G",      0x1292, "iPhone1,2",   "n82ap", 304230656,  310391040 },
    { "iPhone 3G[s]",   0x1294, "iPhone2,1",   "n88ap", 35104,      35104 },
    { "iPhone 4(GSM)",  0x1297, "iPhone3,1",   "n90ap", 35120,      35120 },
    { "iPhone 4(CDMA)", 0x129c, "iPhone3,3",   "n92ap", 100698416,  100698416 },
    { "iPod touch 1G",  0x1291, "iPod1,1",     "n45ap", 304226560,  310386944 },
    { "iPod touch 2G",  0x1293, "iPod2,1",     "n72ap", 34592,      34592 },
    { "iPod touch 3G",  0x1299, "iPod3,1",     "n18ap", 33589538,   33589538 },
    { "iPod touch 4G",  0x129e, "iPod4,1",     "n81ap", 134252848,  134252848 },
    { "iPad",           0x129a, "iPad1,1",     "k48ap", 33589552,   33589552 },
    { "iPad 2(WiFi)",   0x129f, "iPad2,1",     "k93ap", 67144000,   67144000 },
    { "iPad 2(GSM)",    0x12a2, "iPad2,2",     "k94ap", 100698432,  100698432 },
    { "iPad 2(CDMA)",   0x12a3, "iPad2,3",     "k95ap", 33589568,   33589568 }
};

typedef struct {
    const char *name;
    uint16_t productID;
} APPLE_USB_INTERFACE_TYPE;

#define NUM_APPLE_USB_INTERFACES 6

static APPLE_USB_INTERFACE_TYPE APPLE_USB_INTERFACES[NUM_APPLE_USB_INTERFACES] = {
    { "Recovery Mode v1",   0x1280 },
    { "Recovery Mode v2",   0x1281 },
    { "Recovery Mode v3",   0x1282 },
    { "Recovery Mode v4",   0x1283 },
    { "DFU/WTF v1",         0x1222 },
    { "DFU/WTF v2",         0x1227 }
};

enum {
    kAMDeviceNormalMode = 0,
    kAMDeviceRestoreMode = 1,
    kAMDeviceRecoveryMode = 2,
    kAMDeviceDFUMode = 3,
    kAMDeviceNoMode = 4
};
typedef NSInteger AMDeviceMode;


NSString *iOSRestoreGetDeviceConnectionType(uint16_t productID, uint32_t deviceID, BOOL isRestoreMode);
APPLE_MOBILE_DEVICE *iOSRestoreGetDeviceType(uint16_t productID, uint32_t deviceID);

#endif /* DEVICEIDENTIFICATION_H */