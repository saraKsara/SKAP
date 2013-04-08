//
//  SLKLoginAndOutViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-08.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKLoginViewController.h"

@interface SLKLoginViewController ()

@end

@implementation SLKLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [self setSignUpBtn:nil];
    [self setEnterUsernameLabel:nil];
    [self setEnterUsernameTextField:nil];
    [self setEnterPasswordTextField:nil];
    [self setEnterPasswordLabel:nil];
    [super viewDidUnload];
}
- (IBAction)logOut:(id)sender {
}
- (IBAction)logIn:(id)sender {
}
- (IBAction)signUp:(id)sender {
}
@end
