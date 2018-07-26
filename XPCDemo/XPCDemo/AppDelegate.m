//
//  AppDelegate.m
//  XPCDemo
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "XPCProtocol.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSXPCConnection * connectionToService;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"com.tencent.teg.XPC"];
//    _connectionToService = [[NSXPCConnection alloc] initWithListenerEndpoint:endpoint];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCProtocol)];
     [_connectionToService resume];
     
     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
     // We have received a response. Update our text field, but do it on the main thread.
     NSLog(@"Result string was: %@", aString);
     }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
