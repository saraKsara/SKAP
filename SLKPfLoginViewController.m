//
//  SLKPfLoginViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 5/1/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPfLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SLKuser.h"


@interface SLKPfLoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation SLKPfLoginViewController


-(void)didFailWithError:(WSAdSpace *)adSpace type:(NSString *)type message:(NSString *)message error:(NSError *)error
{
    NSLog(@"Adspace did fail with message: %@", message);
}

-(void)didLoadAd:(WSAdSpace *)adSpace adType:(NSString *)adType
{
    NSLog(@"Adspace did load ad with type: %@", adType);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load a Splash Ad as soon as the viewController loads
   // [self loadSplashAd];

    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popThisView)
                                                 name:@"popThisView"
                                               object:nil];
    [self.logInView.logInButton addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];

    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"smallViewBackground.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"prevyArrow.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"nextyArrow.png"] forState:UIControlStateHighlighted];
    
    //    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    //    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    //    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"FacebookDown.png"] forState:UIControlStateHighlighted];
    //    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    //    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    //    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    //
    //    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    //    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    //    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    //    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"TwitterDown.png"] forState:UIControlStateHighlighted];
    //    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    //    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"sing up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"sign up" forState:UIControlStateHighlighted];
    
    // Add login field background
    _fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallViewBackground.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.9f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.9f;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:0.1]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
}
- (void)loadSplashAd {
    
    // Allocate and initiate a WSAdSpace object.Use current viewController as delegate. Use the SID you got from the Widespace online front http://front.widespace.com
    
    splashAdView = [[WSAdSpace alloc] initWithFrame:CGRectNull  sid:@"3e59d2e4-c1e8-4a5c-b0b6-64468cf29a65" autoUpdate:YES autoStart:YES delegate:self];
    
    //For some ad forceAdId is required along with sid.
    [splashAdView setCustomParameters:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"5607",nil] forKeys:[NSArray arrayWithObjects:@"forceAdId",nil]]];
    
    //Add the ads view as a subview to you viewController
    [self.view addSubview:splashAdView];
   // [self.view bringSubviewToFront:splashAdView];
    
}
#pragma mark - Required Delegate Method

- (UIViewController *)rootViewController {
    // You don't need to do more than this here. The widespace SDK simply needs to know about your viewController (i.e self)
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    //[self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
    //[self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 155.0f, 250.0f, 40.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(35.0f, 250.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}
-(void)popThisView
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpApp" object:nil userInfo:nil];
    NSLog(@"current Pf-USER----%@", [PFUser currentUser]);
      NSLog(@"current SLK-USER----%@", [SLKuser currentUser]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
