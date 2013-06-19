//
//  AppDelegate.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SlideShowController.h"
#import "PathAniViewController.h"
#import "EarthEffectViewController.h"    
#import "SafariMultiViewController.h"
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [nc release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    SafariMultiViewController *mvc = [[[SafariMultiViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    MainViewController *mvc = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    nc = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self.window addSubview:nc.view];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([[nc topViewController] isKindOfClass:[SlideShowController class]]) {
        [(SlideShowController *)[nc topViewController] slideStop];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([[nc topViewController] isKindOfClass:[SlideShowController class]]) {
        [(SlideShowController *)[nc topViewController] slideStart];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
