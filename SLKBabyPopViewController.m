//
//  SLKBabyPopViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKBabyPopViewController.h"
#import "SLKJSONService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
@interface SLKBabyPopViewController ()

@end

@implementation SLKBabyPopViewController
{
    UITextView *babyNameTextField;
}
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(addBabyNotification)
     forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20.0, 210.0, 260.0, 40.0);
    button.titleLabel.text = @"Add baby to babyApp";
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
	UILabel *anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 250, 20)];
    [anewBabuLabel setBackgroundColor:[UIColor clearColor]];
    anewBabuLabel.text = @"Type the name of you new baby";
    [anewBabuLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:anewBabuLabel];
    
    babyNameTextField = [[UITextView alloc] initWithFrame:CGRectMake(40.0, 110.0, 200.0, 20.0)];
    
    [self.view addSubview:babyNameTextField];
    
}
-(void)addBabyNotification
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: babyNameTextField.text, @"babyName", nil];

     [[NSNotificationCenter defaultCenter] postNotificationName: @"addBaby" object:nil userInfo:userInfo];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
