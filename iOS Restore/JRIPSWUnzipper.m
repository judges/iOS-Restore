//
//  JRIPSWUnzipper.m
//  iOS Restore
//
//  Created by John Heaton on 4/17/11.
//  Copyright 2011 Springfield High School. All rights reserved.
//

#import "JRIPSWUnzipper.h"
#import "ZipArchive.h"


@implementation JRIPSWUnzipper

@synthesize delegate=_delegate;

- (id)initWithIPSWPath:(NSString *)ipswPath inflationPath:(NSString *)inflationPath {
    if(!ipswPath || !inflationPath) return nil;
    
    if((self = [super init]) != nil) {
        _ipswPath = [ipswPath copy];
        _inflationPath = [inflationPath copy];
    }
    
    return self;
}

- (void)sendDelegateMessage:(SEL)message withObject:(id)object {
    if(_delegate != nil && [_delegate respondsToSelector:message]) 
        [_delegate performSelector:message withObject:object];
}

- (void)beginUnzipping {
//    NSInvocationOperation *inflationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(unzipThisMofo) object:nil];
//    [inflationOperation start];
//    [inflationOperation release];
    
    [NSThread detachNewThreadSelector:@selector(unzipThisMofo) toTarget:self withObject:nil];
}

- (void)unzipThisMofo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ZipArchive *archive = [[ZipArchive alloc] init];
    
    if(![archive UnzipOpenFile:_ipswPath]) {
        [archive release];
        [self sendDelegateMessage:@selector(ipswUnzipperFailedToUnzip) withObject:nil];
        return;
    }
    
    if(![archive UnzipFileTo:_inflationPath overWrite:YES]) {
        [archive UnzipCloseFile];
        [archive release];
        [self sendDelegateMessage:@selector(ipswUnzipperFailedToUnzip) withObject:nil];
        return;
    }
    
    [archive UnzipCloseFile];
    [archive release];
    [self sendDelegateMessage:@selector(ipswUnzipperFinishedUnzipping) withObject:nil];
    
    [pool release];
}

- (void)dealloc {
    [_ipswPath release];
    [_inflationPath release];
    [super dealloc];
}

@end
