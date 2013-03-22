//
//  SLKBabyPopViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKBabyPopViewController.h"

@interface SLKBabyPopViewController ()

@end

@implementation SLKBabyPopViewController

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

	UILabel *anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 20)];
    anewBabuLabel.text = @"EN NY";
    [self.view addSubview:anewBabuLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
