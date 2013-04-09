//
//  SLKSleppViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-09.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKSleppViewController.h"
#import "SLKDaySummaryViewController.h"
@interface SLKSleppViewController ()

@end

@implementation SLKSleppViewController

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


- (void)viewDidUnload {
    [self setTotalOverview:nil];
    [super viewDidUnload];
}
- (IBAction)totalOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.allEvents = YES;
    [self presentModalViewController:controller animated:YES];
}
- (IBAction)sleepOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
        SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.sleep = YES;
    [self presentModalViewController:controller animated:YES];
}
@end
