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
#import "SLKMedzViewController.h"
#import "SLKColors.h"
#import "SLKConstants.h"
#import "SLKUserDefaults.h"
@implementation SLKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    
    [Parse setApplicationId:@"4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl"
                  clientKey:@"lh5Ib7m3Jab71RhCA1dBC2UrMR68dsTBzIlsFu6h"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTheBGColor:)
                                                 name:@"changeBabyColor"
                                               object:nil];

    
        //Set background color
    UIColor *bgcolor = [UIColor colorWithHexValue:kBlueish_Color alpha:1];
    NSString *color;
    
    if ([SLKUserDefaults getTheCurrentBabe] == Nil) {
        //change root view to adding baby
        NSLog(@"there are NOOOOO babies in user default");
    } else{
        if ([[SLKBabyStorage sharedStorage]getCurrentBaby] != Nil) {
            color = [[[SLKBabyStorage sharedStorage]getCurrentBaby] babysColor];
            bgcolor = [UIColor colorWithHexValue:color];
            NSLog(@"there IS a CURRENT baby");
        }else {  NSLog(@"there are babies in user default, but no current");
              //a baby SHOLD BE choosen when created
        }
    }
   // [self setBgColors:bgcolor];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
    NSLog(@"vavava-------- %@", [userInfo valueForKey:@"color"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];
    

    //to get statistics from users
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

       // [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
 //[[SLKBabyStorage sharedStorage] removeAllBabies];
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
-(void) setTheBGColor:(NSNotification *) notification
{
    NSLog(@"nya NOTTT: %@", [notification.userInfo allKeys]);
    NSString *color = [notification.userInfo objectForKey:@"color"];
    UIColor *bgColor = [UIColor colorWithHexValue:color];

    
    self.window.backgroundColor = bgColor;
}
//-(void)setBgColors:(UIColor *)color
//{
//    self.window.backgroundColor = color;
//}

-(void)setUpApp
{
    //TODO:set up nicer
    //set segmentcontrol on tabbar here?????
    //check if there is babies and set rootview to settings if not, so user can add baby
    
    self.tabBarController = [[UITabBarController alloc] init];
//    NSArray *array = [NSArray arrayWithObjects:navController,[self createViewControllersForStoryboards:@[ @"Feed", @"Diaper", @"Medz",@"calendar"]], nil];
//    self.tabBarController.viewControllers = array;
    self.tabBarController.viewControllers = [self createViewControllersForStoryboards:@[ @"Feed", @"Diaper", @"Medz",@"calendar"]];
    
    // Tab styling :)
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[[self tabBarController] tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bg_sel"]];
    
    NSArray *statusItems = [[NSArray alloc] initWithObjects:@"one", @"two",@"three", nil];//or baby amount
    UISegmentedControl *statusSegments = [[UISegmentedControl alloc] initWithItems:statusItems];
  
   // self.toolbarItems = toolbarItems;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:statusSegments];
     NSArray *toolbarItems = [[NSArray alloc] initWithObjects:item, nil];
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 3210, 150)];
//    [toolBar setItems:toolbarItems];
    [self.tabBarController setToolbarItems:toolbarItems];
    
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
//    
//    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithTitle:@"menue"
//                                                                style:UIBarButtonItemStyleBordered
//                                                               target:[[_tabBarController viewControllers]objectAtIndex:0]
//                                                               action:@selector(showMenue)];
 
    
   // [[[self tabBarController]navigationItem] setLeftBarButtonItem:menuBtn];
//    [self.window setRootViewController: navController];
    [self.window setRootViewController:self.tabBarController];
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
