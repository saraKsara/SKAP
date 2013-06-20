//  SLKAppDelegate.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
#import <Parse/Parse.h>
#import "SLKAppDelegate.h"
#import "SLKPARSEService.h"
#import "SLKPfLoginViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "ParentFigures.h"
#import "SLKMedzViewController.h"
#import "SLKColors.h"
#import "SLKConstants.h"
#import "SLKUserDefaults.h"
#import "SLKSettingsViewController.h"
#import "SLKAddBabyViewController.h"
#import "SLKParentStorage.h"
#import "SLKFirtsTimeViewController.h"
#import "SLKTababrController.h"
#import "SLKTabbar.h"
#import "SLKPfSingupViewController.h"
#import "SLKuser.h"
#import "SLKCreateBabyViewController.h"


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
    
    
         [SLKUserDefaults resetDate];
    
    
    //to get statistics from users
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    //TODO: use delegate methods instead?
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
    
    
    
    
     
  /* ***********************  Just for testing, uncomment to use real login and fetch data *********************** */
        [self setUpApp];
     
    
    
  /*  
   *********************** Just for testing, uncomment to use real login and fetch data ***********************

   //TODO: if user was invited...
   if ([PFUser currentUser] != nil) { // No user logged in
        [self setUpAppFirstTime];
        NSLog(@"no current user");
    }
    else //there are something in storage??
    {
        NSString* babyId = [[PFUser currentUser] objectForKey:kBabyId];
        NSLog(@"babiID: %@", babyId);
        if ([[SLKBabyStorage sharedStorage] getBabyWithiD:babyId])//[[SLKBabyStorage sharedStorage] getCurrentBaby]
        {
            NSLog(@"the current users baby (%@) is also in babystorage, setUpApp!", [[[SLKBabyStorage sharedStorage] getCurrentBaby] babyId]);
            [self setUpApp];
        }
        else if (![[SLKBabyStorage sharedStorage] getBabyWithiD:babyId]) {
            NSLog(@"the current babe is NOT in babystorage! Create it and start app when baby exists");
            //     [self setUpAppFirstTime];
            [SLKPARSEService getBabyWithId:babyId onSuccess:^(PFObject *object)
             {
                 NSLog(@"BABY with name: %@ is now in storage (id %@)", [object objectForKey:@"name"], [object objectForKey:kBabyId]);
                 [self setUpApp];
             } onFailure:^(PFObject *object) {}];
            
            
            //  [self setUpAppFirstTime];
        }
    }
    
    // [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //[[SLKBabyStorage sharedStorage] removeAllBabies];
    // [[SLKParentStorage sharedStorage] removeAllParents];
    */
   
   
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
    ///FROM PARSE TUTORIAL
    
    // Create the log in view controller
    //      PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    
    SLKPfLoginViewController *logInViewController = [[SLKPfLoginViewController alloc]init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    //        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    SLKPfSingupViewController *signUpViewController = [[SLKPfSingupViewController alloc]init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    //        [self presentViewController:logInViewController animated:YES completion:NULL];
    
    
    [self.window setRootViewController:logInViewController];
    //    [self.window setRootViewController:signUpViewController];
    [self.window makeKeyAndVisible];
    
    //    }
    
    
    //OLD
    //    SLKPfLoginViewController *lvc = [[SLKPfLoginViewController alloc]init];
    //    SLKPfSingupViewController *svc = [[SLKPfSingupViewController alloc]init];
    //    lvc.delegate = self;
    //
    //   [self.window setRootViewController:svc];
    //    [self.window makeKeyAndVisible];
    //
    
    
    //    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SLKConfigViewController alloc] init]];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    [self.window makeKeyAndVisible];
    //    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //    SLKFirtsTimeViewController *controller = [sb instantiateInitialViewController];
    //    [self.window setRootViewController:controller];
    //    [self.window makeKeyAndVisible];
}
#pragma mark PFSignUpViewControllerDelegate
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    //    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
    
    //    SLKuser *parentUser= [[SLKuser alloc] init];
    //    parentUser.parentId = user.objectId;
    //    parentUser.name = user.username;
    //    parentUser.email = user.email;
    
    //TODO: if user got invited with one babyId
    //    [[PFUser currentUser] setObject:@"theBabbyIdFromInvitation" forKey:kBabyId];
    //    NSString* babyId = [[PFUser currentUser] objectForKey:kBabyId];
    //    NSLog(@"%@", babyId);
    [self createBaby];
    [SLKUserDefaults setTheCurrentParent: [[PFUser currentUser] objectId]];
    NSLog(@"didSignUpUser APPDELEGATE %@", user.username);
}
-(void)createBaby
{
    NSLog(@"create baby APPDELEGATE");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CreateBaby" bundle:nil];
    //    SLKFirtsTimeViewController *controller = [sb instantiateInitialViewController];
    //    [self.window setRootViewController:controller];
    //    [self.window makeKeyAndVisible];
    
    SLKCreateBabyViewController *createBabyVC =  [sb instantiateInitialViewController];
    [self.window setRootViewController:createBabyVC];
    [self.window makeKeyAndVisible];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"\n\n LOGIN-----> APPDELEGATE ----------> \n\n");
    NSString* babyId = [[PFUser currentUser] objectForKey:kBabyId];
    
    if (![[SLKBabyStorage sharedStorage] getBabyWithiD:babyId]) {
        NSLog(@"the current babe is NOT in babystorage! Create it and start app when baby exists");
        [SLKPARSEService getBabyWithId:babyId onSuccess:^(PFObject *object)
         {
             NSLog(@"BABY with name: %@ is now in storage (id %@)", [object objectForKey:@"name"], [object objectForKey:kBabyId]);
             
             
             [SLKUserDefaults setTheCurrentBabe:[[PFUser currentUser] objectForKey:kBabyId]];

             [self setUpApp];
         } onFailure:^(PFObject *object) {}];
        
        
        //  [self setUpAppFirstTime];
    } else {
        [self setUpApp];
    }
}

#pragma mark setupapp
-(void)setUpApp
{
    self.tabBarController = [[SLKTababrController alloc] init];
    UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UIStoryboard *calendarStoryboard  = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    UIStoryboard *mainStoryboard  = [UIStoryboard storyboardWithName:@"Feed" bundle:nil];
    
    NSMutableArray* viewControllers = [[NSMutableArray alloc] init];
    
    [viewControllers addObject: [mainStoryboard instantiateInitialViewController]];
    [viewControllers addObject:[calendarStoryboard instantiateInitialViewController]];
    [viewControllers addObject: [settingStoryboard instantiateInitialViewController]];
    
    
    self.tabBarController.viewControllers = viewControllers;
    // Tab styling
    
    UITabBarItem *tabItemCal =  [[[[self tabBarController] tabBar] items] objectAtIndex:1];
    [tabItemCal setTitle:@"OverView"];
    [tabItemCal setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];
    
    UITabBarItem *tabItemMain =  [[[[self tabBarController] tabBar] items] objectAtIndex:0];
    [tabItemMain setTitle:@"Log babys activites"];
    [tabItemMain setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];
    
    UITabBarItem *tabItemMenue =  [[[[self tabBarController] tabBar] items] objectAtIndex:2];
    [tabItemMenue setTitle:@"Settings"];
    [tabItemMenue setImage:[UIImage imageNamed:@"blojaLyscopy.png"]];
    
    
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[[self tabBarController] tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bg_sel"]];
    
    NSDate *latestDate = [SLKUserDefaults getLatestEvent];
    if ([latestDate isEqualToDate:[SLKUserDefaults getResetDate]])
    {
        [SLKPARSEService getAllEventswithId:nil];
        NSLog(@"date has been reseted");
    } else [SLKPARSEService getNewEvents];
    
    
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
    
    //    = // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end