//
//  SLKAppDelegate.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface SLKAppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, assign) BOOL online;

@end
