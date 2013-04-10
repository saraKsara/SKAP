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
#import "SLKSettingsViewController.h"
#import "SLKAddBabyViewController.h"
#import "SLKParentStorage.h"
#import "SLKFirtsTimeViewController.h"
@implementation SLKAppDelegate
{
    UISegmentedControl *_segmentControll;
    int numberOfBabies;
    NSArray *babyArray;
    float segmentWidth;
    int selectedIndex;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [Parse setApplicationId:@"4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl"
                  clientKey:@"lh5Ib7m3Jab71RhCA1dBC2UrMR68dsTBzIlsFu6h"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    //to get statistics from users
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTheBGColor:)
                                                 name:@"changeBabyColor"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpApp)
                                                 name:@"setUpApp"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpAppFirstTime)
                                                 name:@"setUpAppFirstTime"
                                               object:nil];

    
    NSString *color;
    
    // [SLKPARSEService getAllObjects];
    
    //TODO: on complete:
    
    //if there are no babies in storage after getting from server:
    
    //TODO: if you where invited...
    
    if ([[[SLKParentStorage sharedStorage]parentArray]count] == 0 ) {
        
        NSLog(@"\n\n\n there are NOOOOO parents in user default, add one! \n\n\n");
       
    [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpAppFirstTime" object:nil userInfo:nil];

        
    } else //there are babies in storage
    {
        if ([[SLKBabyStorage sharedStorage]getCurrentBaby] != nil) {
            color = [[[SLKBabyStorage sharedStorage]getCurrentBaby] babysColor];
            NSLog(@"there IS a CURRENT baby :) ");
        } else if ( [SLKUserDefaults getTheCurrentBabe] == nil)
        {
            NSLog(@"\n\n\n BAD!!! there are babies in storage, but no current... BAD \n\n\n");
        }
//           [self setUpAppFirstTime];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpApp" object:nil userInfo:nil];

        //NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];
    }
 
       // [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //[[SLKBabyStorage sharedStorage] removeAllBabies];
   // [[SLKParentStorage sharedStorage] removeAllParents];

    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PFPush storeDeviceToken:deviceToken];
    [PFPush subscribeToChannelInBackground:@""];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to register for remote notification---%@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}


//-(void) setTheBGColor:(NSNotification *) notification
//{
//    
//    NSString *color = [notification.userInfo objectForKey:@"color"];
//    UIColor *bgColor = [UIColor colorWithHexValue:color];
//    
//    UIImage *image = [self drawImageBackgroundWithColor:bgColor];
//    UIImage *imageText =[self drawBIGText:@"HIRE US" inImage:image atPoint:CGPointMake(20, 55)];
//    self.window.backgroundColor = [UIColor colorWithPatternImage:imageText];
//}

-(void)setUpAppFirstTime
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SLKFirtsTimeViewController *controller = [sb instantiateInitialViewController];
    [self.window setRootViewController:controller];
    [self.window makeKeyAndVisible];
}
-(void)setUpApp
{
   
    self.tabBarController = [[UITabBarController alloc] init];
    UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
       UIStoryboard *calendarStoryboard  = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    UIStoryboard *mainStoryboard  = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
  
    NSMutableArray* viewControllers = [[NSMutableArray alloc] init];
    [viewControllers addObject:[calendarStoryboard instantiateInitialViewController]];
    [viewControllers addObject: [mainStoryboard instantiateInitialViewController]];
    [viewControllers addObject: [settingStoryboard instantiateInitialViewController]];
    
    
    self.tabBarController.viewControllers = viewControllers;
        
    // Tab styling
   
    UITabBarItem *tabItemCal =  [[[[self tabBarController] tabBar] items] objectAtIndex:1];
    [tabItemCal setTitle:@"OverView"];
    [tabItemCal setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];
    
    UITabBarItem *tabItemMain =  [[[[self tabBarController] tabBar] items] objectAtIndex:0];
    [tabItemMain setTitle:@"Log babys activites"];
    [tabItemMain setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];

    UITabBarItem *tabItemMenue =  [[[[self tabBarController] tabBar] items] objectAtIndex:1];
    [tabItemMenue setTitle:@"Settings"];
    [tabItemMenue setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];

    
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[[self tabBarController] tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bg_sel"]];
    
        
//    babyArray = [[SLKBabyStorage sharedStorage] babyArray];
//    numberOfBabies = babyArray.count;
    
//    NSMutableArray *segmentArray = [[NSMutableArray alloc] initWithObjects:@"menu", nil];
//    int i = 1;
//    for (Baby *babe in babyArray)
//    {
//        [segmentArray addObject:babe.name];
//        i++;
//    }
    
  
    
    //TODO: move to set up class???
//    _segmentControll = [[UISegmentedControl alloc] initWithItems:segmentArray];
//    _segmentControll.frame = CGRectMake(0, 0, 320, 50);
//    _segmentControll.segmentedControlStyle = UISegmentedControlStylePlain;
//    _segmentControll.selectedSegmentIndex = 1;//TODO: == current babe
//    segmentWidth = 320 /(numberOfBabies +1);
//    
//    for (int i = 0; i <= numberOfBabies; i++) {
//        {
//            if (i == 0) {
//                UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:kBlueish_Color alpha:0.8]];
//                UIImage *imageText =[self drawText:@"menu" inImage:image atPoint:CGPointMake(20, 25)];
//              
//                [_segmentControll setImage:imageText forSegmentAtIndex:i];
//            } else {
//                NSString *color = [[babyArray objectAtIndex:i-1] babysColor];
//                UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:color]];
//                
//                UIImage *imageText =[self drawText:[[babyArray objectAtIndex:i-1] name] inImage:image atPoint:CGPointMake(20, 25)];
//                
//                [_segmentControll setImage:imageText forSegmentAtIndex:i];
//            }
//            
//        }
//        
//        [_segmentControll addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
//        
//        [self.tabBarController.view addSubview:_segmentControll];
//        [_segmentControll setSelected:NO];
//        [_segmentControll setHighlighted:NO];
//        [_segmentControll setTintColor:[UIColor clearColor]];


    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
//}

}

//
////TODO: make theese "all in one"
//-(UIImage*)drawImageBackgroundWithColor:(UIColor*)color
//{
//    //as big as 320/(numberofbabies+1)
//    UIGraphicsBeginImageContext(CGSizeMake(320, 500));
//    [color setFill];
//    UIRectFill(CGRectMake(0, 0, 320, 500));
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

//-(UIImage*) drawBIGText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point
//{
//    
//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:25];
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
//    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
//    [[UIColor blackColor] set];
//    [text drawInRect:CGRectIntegral(rect) withFont:font];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}


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
