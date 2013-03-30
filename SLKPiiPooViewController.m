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
    BOOL checkboxSelected;
    UIImage *checkedImage;
    UIImage *unCheckedImage;
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
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _nameOfBabyLabel.text = [NSString stringWithFormat:@"Poo and pee of %@",currentBabe.name];
    
    checkedImage = [UIImage imageNamed:@"checkedBox"];
    unCheckedImage = [UIImage imageNamed:@"uncheckedBox"];
    
    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
    
//    _normalPii.image = [UIImage imageNamed:@"uncheckedBox"];
//    _tooMuchPii.image = [UIImage imageNamed:@"uncheckedBox"];
//    _tooLittlePii.image = [UIImage imageNamed:@"uncheckedBox"];
    
 
}

- (void)toggleButton: (id) sender
{
//    NSLog(@"toggleButton");
//    checkboxSelected = !checkboxSelected;
//    UIImageView* check = (UIImageView*) sender;
//    if (checkboxSelected == NO)
//        [check setImage:[UIImage imageNamed:@"uncheckedBox.png"]];
//    else
//        [check setImage:[UIImage imageNamed:@"checkedBox.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePoo:(id)sender
{
    
}
- (IBAction)check:(id)sender {
    
    UIButton* check = (UIButton*) sender;
    if (check.imageView.image == checkedImage)
    {
     [check setImage:unCheckedImage forState:UIControlStateNormal];
    }else
    {
        [check setImage:checkedImage forState:UIControlStateNormal];
    }
}
@end
