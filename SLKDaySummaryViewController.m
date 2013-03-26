//
//  SLKSubmitDayViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKDaySummaryViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKDateUtil.h"
#import "SLKDates.h"
@interface SLKDaySummaryViewController ()

@end

@implementation SLKDaySummaryViewController
{
    Baby *currentBaby;
    NSDate *currentDay;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    currentDay = [NSDate date];
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ today, %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    
    //TODO: decide how to represent pee and poo
    _peeLabel.text = [NSString stringWithFormat:@"Peed: %@ ml/times", currentBaby.pii];
    _pooLabel.text =  [NSString stringWithFormat:@"Pooped %@ ml/times", currentBaby.poo];
    
    //TODO: for each time span, create a string that tell what time and what and how much the baby ate
     _foodLabel.text =  [NSString stringWithFormat:@"Ate %@ ml/times", currentBaby.feedTimespan];
    
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

- (IBAction)nextDay:(id)sender
{
    currentDay = [currentDay dateByAddingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ today, %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
}

- (IBAction)prevDay:(id)sender
{
    currentDay = [currentDay dateBySubtractingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ today, %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
}
@end
