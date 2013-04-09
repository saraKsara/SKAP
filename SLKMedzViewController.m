//
//  SLKMedzViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-28.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKMedzViewController.h"
#import "SLKConstants.h"
#import "SLKColors.h"
#import "Baby.h"
#import "SLKBabyStorage.h"
#import "SLKDaySummaryViewController.h"
@interface SLKMedzViewController ()

@end

@implementation SLKMedzViewController
{
    Baby *currentBabe;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allMedsOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.medz = YES;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)totalOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.allEvents = YES;
    [self presentModalViewController:controller animated:YES];
}
@end
