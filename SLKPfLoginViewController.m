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


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.logInView.logInButton addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];

    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"smallViewBackground.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bo.png"]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"prevyArrow.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"nextyArrow.png"] forState:UIControlStateHighlighted];
    
       
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"checkedNO.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"checkedYES.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"sing up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"sign up" forState:UIControlStateHighlighted];
    
    // Add login field background
    _fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titsSmall.png"]];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];

    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 240.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}
//-(void)popThisView
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpApp" object:nil userInfo:nil];
//    NSLog(@"current Pf-USER----%@", [PFUser currentUser]);
//      NSLog(@"current SLK-USER----%@", [SLKuser currentUser]);
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
