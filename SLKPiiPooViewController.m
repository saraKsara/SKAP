//
//  SLKPiiPooViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPiiPooViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"

@interface SLKPiiPooViewController ()

@end

@implementation SLKPiiPooViewController
{
    Baby *currentBabe;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	self.title =@"a poppy?";
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _nameOfBabyLabel.text = [NSString stringWithFormat:@"Poo and pee of %@",currentBabe.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePoo:(id)sender
{
    
//    [[SLKBabyStorage sharedStorage] createBabyWithName:currentBabe.name
//                                                babyId:currentBabe.babyId
//                                                   pii:currentBabe.pii
//                                                   poo:[NSNumber numberWithInt:88]
//                                          feedTimespan:currentBabe.feedTimespan
//                                                bottle:currentBabe.bottle
//                                                breast:currentBabe.breast
//                                                  date:nil];
}
@end
