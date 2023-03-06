//
//  AppDelegate.m
//  Translater
//
//  Created by qiancheng on 2023/2/26.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

static NSWindow *window = nil;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    window = NSApplication.sharedApplication.windows[0];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) [window makeKeyAndOrderFront:nil];
    return YES;
}
@end
