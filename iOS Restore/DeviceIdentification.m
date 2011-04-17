//
//  DeviceIdentification.m
//  iOS Restore
//
//  Created by John Heaton on 4/17/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#include "DeviceIdentification.h"


APPLE_MOBILE_DEVICE *iOSRestoreGetDeviceType(uint16_t productID, uint32_t deviceID) {
    for(int i=0;i<NUM_APPLE_USB_INTERFACES;++i) {
        if(APPLE_USB_INTERFACES[i].productID == productID) {
            if(i < 4) {
                for(int i=0;i<NUM_APPLE_MOBILE_DEVICES;++i) {
                    if(APPLE_MOBILE_DEVICES[i].recoveryDeviceID == deviceID) {
                        return &APPLE_MOBILE_DEVICES[i];
                    }
                }
            } else {
                for(int i=0;i<NUM_APPLE_MOBILE_DEVICES;++i) {
                    if(APPLE_MOBILE_DEVICES[i].dfuDeviceID == deviceID) {
                        return &APPLE_MOBILE_DEVICES[i];
                    }
                }
            }
        }
    }
    
    for(int i=0;i<NUM_APPLE_MOBILE_DEVICES;++i) {
        if(APPLE_MOBILE_DEVICES[i].productID == productID) {
            return &APPLE_MOBILE_DEVICES[i];
        }
    }
    
    return NULL;//(APPLE_MOBILE_DEVICE){NULL, 0, NULL, NULL, 0, 0};
}

NSString *iOSRestoreGetDeviceConnectionType(uint16_t productID, uint32_t deviceID, BOOL isRestoreMode) {
    NSString *modeName = (isRestoreMode ? @"Restore" : @"Normal");
    NSString *deviceName = @"Unknown Device";
    
    APPLE_MOBILE_DEVICE *device = iOSRestoreGetDeviceType(productID, deviceID);
    deviceName = [NSString stringWithUTF8String:device->name];
    
    for(int i=0;i<NUM_APPLE_USB_INTERFACES;++i) {
        if(APPLE_USB_INTERFACES[i].productID == productID) {
            if(i < 4)
                modeName = @"Recovery";
            else
                modeName = @"DFU";
        }
    }
    
    return [NSString stringWithFormat:@"%@: %@ Mode", deviceName, modeName];
}