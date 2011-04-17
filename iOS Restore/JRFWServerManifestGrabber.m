//
//  JRFWServerManifestGrabber.m
//  iOS Restore
//
//  Created by John Heaton on 4/16/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import "JRFWServerManifestGrabber.h"


@implementation JRFWServerManifestGrabber

@synthesize delegate=_delegate;
@synthesize started;

- (id)init {
    if((self = [super init]) != nil) {
        _rawResponse = [[NSMutableData data] retain];
    }
    
    return self;
}

- (void)beginGrabbing {
    if(!started && _delegate != nil) {
        started = YES;
        
        [[[NSURLConnection alloc] initWithRequest:
          [[[NSURLRequest alloc] initWithURL:
            [NSURL URLWithString:@"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/com.apple.jingle.appserver.client.MZITunesClientCheck/version/"]] autorelease] delegate:self startImmediately:YES] autorelease];
    }
}

- (void)sendDelegateMessage:(SEL)message withObject:(id)object {
    if(_delegate != nil && [_delegate respondsToSelector:message]) 
        [_delegate performSelector:message withObject:object];
}

// delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    started = NO;
    
    [_rawResponse release];
    _rawResponse = [[NSMutableData data] retain];
    
    [self sendDelegateMessage:@selector(serverManifestGrabberFailedWithErrorDescription:) withObject:@"Failed to download iTunes server information."];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_rawResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    started = NO;
    
    NSMutableDictionary *manifestDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSDictionary *rawDict = [[[[NSString alloc] initWithData:(NSData *)_rawResponse encoding:NSUTF8StringEncoding] autorelease] propertyList];
    NSDictionary *MobileDeviceSoftwareVersionsByVersion = [rawDict objectForKey:@"MobileDeviceSoftwareVersionsByVersion"];
    
    for(NSString *versionKey in [MobileDeviceSoftwareVersionsByVersion allKeys]) {
        NSDictionary *versionDict = [MobileDeviceSoftwareVersionsByVersion objectForKey:versionKey];
        NSDictionary *softwareVersions = [versionDict objectForKey:@"MobileDeviceSoftwareVersions"];
        
        for(NSString *deviceModel in [softwareVersions allKeys]) {
            NSDictionary *deviceEntry = [softwareVersions objectForKey:deviceModel];
            NSMutableDictionary *modelEntry = [NSMutableDictionary dictionary];
            
            for(NSString *weirdValue in [deviceEntry allKeys]) {
                NSDictionary *firmwareEntry = [deviceEntry objectForKey:weirdValue];
                
                NSDictionary *restoreInfo = [firmwareEntry objectForKey:@"Restore"];
                if(!restoreInfo)
                    restoreInfo = [firmwareEntry objectForKey:@"PurchasedRestore"]; // Might have a legal issue here. Can be removed.
                
                BOOL isWantedEntry = (restoreInfo != nil);
                
                if(isWantedEntry) {
                    NSDictionary *existingEntry = [modelEntry objectForKey:[restoreInfo objectForKey:@"ProductVersion"]];
                    if(!existingEntry) {
                        [modelEntry setObject:[NSDictionary dictionaryWithObjectsAndKeys:[restoreInfo objectForKey:@"BuildVersion"], @"Build", [restoreInfo objectForKey:@"FirmwareURL"], @"URL", nil] forKey:[restoreInfo objectForKey:@"ProductVersion"]];
                    }
                }
            }
            
            if([manifestDict objectForKey:deviceModel] != nil) {
                [[manifestDict objectForKey:deviceModel] addEntriesFromDictionary:modelEntry];
            } else {
                [manifestDict setObject:modelEntry forKey:deviceModel];
            }
        }
    }
    
    started = NO;
    [self sendDelegateMessage:@selector(serverManifestGrabberDidFinishWithManifest:) withObject:manifestDict];
}

- (void)dealloc {
    [_rawResponse release];    
    [super dealloc];
}

@end
