//
//  SLKAppDelegate.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//
#import <Parse/Parse.h>
#import "SLKAppDelegate.h"
#import "SLKPARSEService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
@implementation SLKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    
    [Parse setApplicationId:@"4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl"
                  clientKey:@"lh5Ib7m3Jab71RhCA1dBC2UrMR68dsTBzIlsFu6h"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
   
    //to get statistics from users
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

       // [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
 
 [SLKPARSEService getAllObjects];
    [self setUpApp];

  //   //TODO: add "callback block"
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PFPush storeDeviceToken:deviceToken];
    [PFPush subscribeToChannelInBackground:@""];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to register for remotenotification---%@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

-(NSArray*) createViewControllersForStoryboards:(NSArray *) storyboards
{
    NSMutableArray* viewControllers = [NSMutableArray new];
    
    for (id storyboard in storyboards)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
        [viewControllers addObject: [sb instantiateInitialViewController]];
    }
    
    return viewControllers;
}
-(void)setUpApp
{
    
    
    self.tabBarController = [[UITabBarController alloc] init];
//    NSArray *array = [NSArray arrayWithObjects:navController,[self createViewControllersForStoryboards:@[ @"Feed", @"Diaper", @"Medz",@"calendar"]], nil];
//    self.tabBarController.viewControllers = array;
    self.tabBarController.viewControllers = [self createViewControllersForStoryboards:@[ @"Feed", @"Diaper", @"Medz",@"calendar"]];
    
    // Tab styling :)
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[[self tabBarController] tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bg_sel"]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithTitle:@"menue"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:[[_tabBarController viewControllers]objectAtIndex:0]
                                                               action:@selector(showMenue)];
 
    
    [[[self tabBarController]navigationItem] setLeftBarButtonItem:menuBtn];
    [self.window setRootViewController: navController];
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //TODO: think about this:
    NSLog(@"applicationDidEnterBackground, update data on server here? and when actually updating?");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
