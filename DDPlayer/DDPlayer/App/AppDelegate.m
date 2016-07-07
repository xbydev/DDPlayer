//
//  AppDelegate.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/13.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalVideoViewController.h"
#import "NetVideoViewController.h"
#import "MoreViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.window.rootViewController = self.homeCtrl;
    
    _homeCtrl.tabBar.tintColor = [UIColor redColor];
    
    LocalVideoViewController *localCtrl = [[LocalVideoViewController alloc] initWithNibName:@"LocalVideoViewController" bundle:nil];
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:localCtrl];
    navi1.tabBarItem.title  = @"视频";
    navi1.tabBarItem.image = [UIImage imageNamed:@"tabbar_local"];
    
    //wifi传输
    NetVideoViewController *netCtrl = [[NetVideoViewController alloc] initWithNibName:@"NetVideoViewController" bundle:nil];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:netCtrl];
    navi2.tabBarItem.title  = @"WiFi";
    navi2.tabBarItem.image = [UIImage imageNamed:@"tabbar_net"];
    
    MoreViewController *moreCtrl = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:moreCtrl];
    navi3.tabBarItem.title  = @"更多";
    navi3.tabBarItem.image = [UIImage imageNamed:@"tabbar_local"];
    
    _homeCtrl.viewControllers=@[navi1,navi2,navi3];
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
