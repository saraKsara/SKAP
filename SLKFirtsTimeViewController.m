//
//  SLKFirtsTimeViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-10.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKFirtsTimeViewController.h"
#import "SLKSettingsViewController.h"
#import "SLKParentStorage.h"
@interface SLKFirtsTimeViewController ()

@end

@implementation SLKFirtsTimeViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    SLKSettingsViewController *controller = [sb instantiateViewControllerWithIdentifier:@"addPersonViewcontroller"];
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)login:(id)sender {
    
    //TODO:
//    //if username and password is OK, start app. else alert!
//     if ([[[SLKParentStorage sharedStorage]parentArray]count] == 0 )//TODO: change this to check if the password and username is correct instead...
//     {
////         UIAlertView *alertNotGuilty = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Password or username is incorrect please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////         [alertNotGuilty show];
//     } else {
     [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpApp" object:nil userInfo:nil];
     //}
}
- (void)viewDidUnload {
    [self setUsernameTF:nil];
    [self setPasswordTF:nil];
    [super viewDidUnload];
}
@end
