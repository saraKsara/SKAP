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
@implementation SLKAppDelegate
{
    UISegmentedControl *_segmentControll;
    int numberOfBabies;
    NSArray *babyArray;
    float segmentWidth;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [Parse setApplicationId:@"4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl"
                  clientKey:@"lh5Ib7m3Jab71RhCA1dBC2UrMR68dsTBzIlsFu6h"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTheBGColor:)
                                                 name:@"changeBabyColor"
                                               object:nil];

    
    NSString *color;
     [SLKPARSEService getAllObjects];
    
    //TODO: on complete:
    
    //if there are no babies in storage after getting from server:
    if ([[[SLKBabyStorage sharedStorage]babyArray]count] == 0 ) {
        
        //change root view to adding baby
        //[self setUpAppWithAddingBabyView];
        NSLog(@"\n\n\n there are NOOOOO babies in user default, add one! \n\n\n");
        
    } else //there are babies in storage
    {
        if ([[SLKBabyStorage sharedStorage]getCurrentBaby] != nil) {
            color = [[[SLKBabyStorage sharedStorage]getCurrentBaby] babysColor];
            NSLog(@"there IS a CURRENT baby :) ");
        } else if ( [SLKUserDefaults getTheCurrentBabe] == nil)
        {
            NSLog(@"\n\n\n BAD!!! there are babies in storage, but no current... BAD \n\n\n");
        }
        
        [self setUpApp];
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];
    

    //to get statistics from users
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

       // [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
 //[[SLKBabyStorage sharedStorage] removeAllBabies];

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
-(void) setUpSegmentController:(NSNotification *) notification
{

}
-(void) setTheBGColor:(NSNotification *) notification
{
    NSLog(@"nya NOTTT: %@", [notification.userInfo allKeys]);
    NSString *color = [notification.userInfo objectForKey:@"color"];
    UIColor *bgColor = [UIColor colorWithHexValue:color];
    self.window.backgroundColor = bgColor;
}


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
    
        
    babyArray = [[SLKBabyStorage sharedStorage] babyArray];
    NSMutableArray *segmentArray = [[NSMutableArray alloc] initWithObjects:@"menu", nil];
    
    numberOfBabies = babyArray.count;
    
    //IF adding new baby, set up new segmentcontrol! else, ....
    int i = 1;
    for (Baby *babe in babyArray)
    {
        [segmentArray addObject:babe.name];
        i++;
    }
    //TODO: move to set up class???
    _segmentControll = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControll.frame = CGRectMake(0, 0, 320, 50);
    _segmentControll.segmentedControlStyle = UISegmentedControlStylePlain;
    _segmentControll.selectedSegmentIndex = 1;//TODO: == current babe
    segmentWidth = 320 /(numberOfBabies +1);
    
    for (int i = 0; i <= numberOfBabies; i++) {
        {
            if (i == 0) {
                UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:kBlueish_Color alpha:0.8]];
                UIImage *imageText =[self drawText:@"menu" inImage:image atPoint:CGPointMake(20, 25)];
                
                [_segmentControll setImage:imageText forSegmentAtIndex:i];
            } else {
                NSString *color = [[babyArray objectAtIndex:i-1] babysColor];
                UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:color]];
                
                UIImage *imageText =[self drawText:[[babyArray objectAtIndex:i-1] name] inImage:image atPoint:CGPointMake(20, 25)];
                
                [_segmentControll setImage:imageText forSegmentAtIndex:i];
            }
            
        }
        
        [_segmentControll addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
        
        [self.tabBarController.view addSubview:_segmentControll];
        [_segmentControll setSelected:NO];
        [_segmentControll setHighlighted:NO];
        [_segmentControll setTintColor:[UIColor clearColor]];

  
   // self.toolbarItems = toolbarItems;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:statusSegments];
//     NSArray *toolbarItems = [[NSArray alloc] initWithObjects:item, nil];

        
        //    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 3210, 150)];
//    [toolBar setItems:toolbarItems];
   // [self.tabBarController setToolbarItems:toolbarItems];
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

}

- (IBAction)segmentAction:(id)sender {
    
    //TODO: set menu not selected when setting view is dissmissed
    if ( _segmentControll.selectedSegmentIndex == 0 ) {
        //        [self performSegueWithIdentifier:@"menueSeg" sender:self];
        [self showMenue];
    } else {
        for (int i = 0; i < numberOfBabies; i++) {
            if ( _segmentControll.selectedSegmentIndex == i+1 ) {
                NSLog(@"change seg %d to %@",_segmentControll.selectedSegmentIndex, [[babyArray objectAtIndex:i] name]);
                [[SLKBabyStorage sharedStorage] setCurrentBaby:[babyArray objectAtIndex:i]];

                NSString *color = [[babyArray objectAtIndex:i] babysColor];
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];
            }
        }
    }
}

-(UIImage*)drawImageWithColor:(UIColor*)color
{
    //as big as 320/(numberofbabies+1)
    UIGraphicsBeginImageContext(CGSizeMake(segmentWidth, 50));
    [color setFill];
    UIRectFill(CGRectMake(0, 0, segmentWidth, 50));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point
{
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor blackColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)showMenue
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    
    SLKSettingsViewController *controller = [sb instantiateInitialViewController];
    [[[self.tabBarController viewControllers] objectAtIndex:0] presentViewController:controller animated:YES completion:^{
        
    }];
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
